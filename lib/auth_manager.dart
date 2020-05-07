import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphql/client.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stronk/api/graphql.dart';
import 'package:stronk/api/graphql/auth.dart';
import 'package:stronk/redux/reducer/app_reducer.dart';

const KEY_SIGNED_IN = "user_signed_in";

const KEY_ACCOUNT_NAME = "account.name";
const KEY_ACCOUNT_EMAIL = "account.email";
const KEY_ACCESS_TOKEN = "account.uid";
const KEY_ID_TOKEN = "account.uid";

/// manages authentication and maintains the current user account
class AuthManager {
  bool get isSignedIn {
    return sharedPrefs.containsKey(KEY_SIGNED_IN) && sharedPrefs.getBool(KEY_SIGNED_IN);
  }

  // injected deps
  GoogleSignIn googleSignIn;
  FirebaseAuth firebaseAuth;
  SharedPreferences sharedPrefs;
  Store store;

  AuthManager({
    @required this.googleSignIn,
    @required this.firebaseAuth,
    @required this.sharedPrefs,
    @required this.store
  });

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

    // create account on server and store credentials locally
    var account = await createAccountOnServer(util, authResult.user.displayName, authResult.user.email, credentials);
    _setCurrentAccount(account);

    store.dispatch(LoginCompletedAction(currentAccount: account));
    return account;
  }

  Future<Account> createAccountOnServer(GraphQLUtility util, String name, String email, Credentials credentials) async {
    // mutation request to create the account on the server
    final options = MutationOptions(
      documentNode: gql(createUser(name, name, email)),
    );

//    return Account(
//      name: name,
//      username: name,
//      email: email,
//      credentials: credentials);

    // need to set the token using the firebase account before accessing the client to create the user
    util.updateIdToken(credentials.idToken);
    final result = await util.client.mutate(options);
    if (result.hasException) {
      // TODO check if account already created
      // TODO handle failure flow
      log("error creating user ${result.exception}");
    }

    final createdUser = result.data["CreateUser"]["user"];
    return Account(
        name: createdUser["name"],
        username: createdUser["username"],
        email: createdUser["email"],
        credentials: credentials);
  }

  Account get currentAccount {
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
    sharedPrefs.setBool(KEY_SIGNED_IN, true);
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
