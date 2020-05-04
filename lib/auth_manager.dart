import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

const KEY_ACCOUNT_NAME = "account.name";
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
  Future<void> handleSignIn() async {
    // first try to get current account info from shared pref
    var account = await _getCurrentAccount();
    // user hasn't logged in the app
    if (account == null) {
      account = await _initialSignIn();
    }

    _currentAccountController.add(account);
   }

  Future<Account> _initialSignIn() async {
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
    // TODO use auth result to create user on server

    // store credentials locally for later use
    var account = Account(
      name : authResult.user.displayName,
      credentials: Credentials(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken)
    );
    _setCurrentAccount(account);
    return account;
  }

  Future<Account> _getCurrentAccount() async {
    final name = sharedPrefs.getString(KEY_ACCOUNT_NAME);
    final accessToken = sharedPrefs.getString(KEY_ACCESS_TOKEN);
    final idToken = sharedPrefs.getString(KEY_ID_TOKEN);

    if (accessToken == null || idToken == null) return null;
    return Account(
      name: name,
      credentials: Credentials(accessToken: accessToken, idToken: idToken)
    );
  }

  Future _setCurrentAccount(Account account) async {
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

  Account({
    @required this.credentials,
    @required this.name,
  });
}