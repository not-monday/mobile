import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stronk/api/graphql.dart';
import 'package:stronk/api/graphql/auth.dart';

const KEY_ACCOUNT_NAME = "account.name";
const KEY_ACCOUNT_EMAIL = "account.email";
const KEY_ACCESS_TOKEN = "account.uid";
const KEY_ID_TOKEN = "account.uid";

/// manages authentication and maintains the current user account
class AuthManager {
  StreamController<Account> _currentAccountController = StreamController.broadcast();

  Stream<Account> get currentAccount {
    return _currentAccountController.stream;
  }

  // injected deps
  GoogleSignIn googleSignIn;
  FirebaseAuth firebaseAuth;
  SharedPreferences sharedPrefs;

  AuthManager({
    @required this.googleSignIn,
    @required this.firebaseAuth,
    @required this.sharedPrefs,
  });

  /// handles the sign in of a user (MUST BE CALLED FOR EVERY SESSION)
  /// First checks if credentials have been cached (stored in local prefs).
  /// If not, it'll start the Firebase Auth interactive sign in process to obtain the credentials
  ///
  /// Once credentials have been obtained, we perform the firebase sign in process to obtain an instance
  /// of the firebase user and notify observers via the stream
  ///
  Future<void> handleSignIn(GraphQLUtility util) async {
    // first try to get current account info from shared pref
    var account = await _getCurrentAccount();
    // user hasn't logged in the app
    if (account == null) {
      account = await initialSignIn(util);
    }

    _currentAccountController.add(account);
  }

  /// only called for first time sign in
  /// - initiates interactive sign on to obtain a google user and converts it
  /// into an `account` to be stored
  /// - creates an account on server
  Future<Account> initialSignIn(GraphQLUtility util) async {
    // start the interactive sign process
    var googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw SignInException(message: "Error signing in");
    }
    final googleAuth = await googleUser.authentication;

    // build auth provider credentials to sign in
    var googleSignInCredentials = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    var authResult = await firebaseAuth.signInWithCredential(googleSignInCredentials);
    var idToken = await authResult.user.getIdToken();
    var credentials = Credentials(accessToken: googleAuth.accessToken, idToken: idToken.token);
    // store credentials locally for later use
    var account = await createAccountOnServer(util, authResult.user.displayName, authResult.user.email, credentials);
    _setCurrentAccount(account);

    return account;
  }

  Future<Account> createAccountOnServer(GraphQLUtility util, String name, String email, Credentials credentials) async {
    // mutation request to create the account on the server
    final options = MutationOptions(
      documentNode: gql(CREATE_USER),
      variables: <String, dynamic>{
        "name": name,
        "username": name,
        "email": email,
      },
    );

    final result = await util.temporaryClient(credentials.idToken).mutate(options);
    if (result.hasException) {
      // TODO check if account already created
      // TODO handle failure flow
      log(result.exception.toString());
    }


    final createdUser = result.data["user"];
    return Account(
        name: createdUser["name"],
        username: createdUser["username"],
        email: createdUser["email"],
        credentials: credentials);
  }

  Future<Account> _getCurrentAccount() async {
    final name = sharedPrefs.getString(KEY_ACCOUNT_NAME);
    final email = sharedPrefs.getString(KEY_ACCOUNT_EMAIL);
    final accessToken = sharedPrefs.getString(KEY_ACCESS_TOKEN);
    final idToken = sharedPrefs.getString(KEY_ID_TOKEN);

    if (accessToken == null || idToken == null) return null;
    return Account(
        name: name, username: name, email: email, credentials: Credentials(accessToken: accessToken, idToken: idToken));
  }

  Future _setCurrentAccount(Account account) async {
    sharedPrefs.setString(KEY_ACCOUNT_NAME, account.name);
    sharedPrefs.setString(KEY_ACCOUNT_EMAIL, account.email);

    sharedPrefs.setString(KEY_ACCESS_TOKEN, account.credentials.accessToken);
    sharedPrefs.setString(KEY_ID_TOKEN, account.credentials.idToken);
  }
}

class Credentials {
  String accessToken;
  String idToken;

  Credentials({this.accessToken, this.idToken});
}

class SignInException implements Exception {
  String message;

  SignInException({@required this.message});
}

class Account {
  Credentials credentials;
  String name;
  String email;
  String username;

  Account({
    @required this.credentials,
    @required this.name,
    @required this.email,
    @required this.username,
  });
}
