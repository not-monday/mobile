import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// manages authentication and maintains the current user account
class AuthManager {
  StreamController<FirebaseUser> currentUserController = StreamController();
  Stream<FirebaseUser> currentUser;

  // injected deps
  GoogleSignIn googleSignIn;
  FirebaseAuth firebaseAuth;
  SharedPreferences sharedPrefs;

  AuthManager({
    @required this.googleSignIn,
    @required this.firebaseAuth,
    @required this.sharedPrefs,
  }) {
    currentUser = currentUserController.stream;
  }

  Future<void> handleSignIn() async {
    // first try to get current account info from shared pref
    var credentials = await _getCurrentCredentials();

    // user hasn't logged in the app
    if (credentials == null) {
      // interactive sign
      var googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw SignInException(message: "Error signing in");
      }
      final googleAuth = await googleUser.authentication;
      // store credentials locally for later use
      credentials = Credentials(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      _setCurrentCredentials(credentials);
    }

    // build auth provider credentials to sign in
    var googleCredentials = GoogleAuthProvider.getCredential(
      accessToken: credentials.accessToken,
      idToken: credentials.idToken,
    );

    var user = (await firebaseAuth.signInWithCredential(googleCredentials)).user;
    currentUserController.add(user);
  }

  Future<Credentials> _getCurrentCredentials() async {
    final accessToken = sharedPrefs.getString(KEY_ACCESS_TOKEN);
    final idToken = sharedPrefs.getString(KEY_ID_TOKEN);

    if (accessToken == null || idToken == null) return null;
    return Credentials(accessToken: accessToken, idToken: idToken);
  }

  Future<Credentials> _setCurrentCredentials(Credentials credentials) async {
    sharedPrefs.setString(KEY_ACCESS_TOKEN, credentials.accessToken);
    sharedPrefs.setString(KEY_ID_TOKEN, credentials.idToken);
  }
}

const KEY_ACCESS_TOKEN = "account.uid";
const KEY_ID_TOKEN = "account.uid";

class Credentials {
  String accessToken;
  String idToken;
  Credentials({this.accessToken, this.idToken});
}

class SignInException implements Exception {
  String message;

  SignInException({@required this.message});
}