import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

const KEY_ACCESS_TOKEN = "account.uid";
const KEY_ID_TOKEN = "account.uid";

/// manages authentication and maintains the current user account
class AuthManager {
  StreamController<FirebaseUser> _currentUserController = StreamController.broadcast();

  Stream<FirebaseUser> get currentUser {
    return _currentUserController.stream;
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
    var credentials = await _getCurrentCredentials();

    // user hasn't logged in the app
    if (credentials == null) {
      // start the interactive sign process
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

    var authResult = await firebaseAuth.signInWithCredential(googleCredentials);
    _currentUserController.add(authResult.user);
  }

  Future<Credentials> _getCurrentCredentials() async {
    final accessToken = sharedPrefs.getString(KEY_ACCESS_TOKEN);
    final idToken = sharedPrefs.getString(KEY_ID_TOKEN);

    if (accessToken == null || idToken == null) return null;
    return Credentials(accessToken: accessToken, idToken: idToken);
  }

  Future _setCurrentCredentials(Credentials credentials) async {
    sharedPrefs.setString(KEY_ACCESS_TOKEN, credentials.accessToken);
    sharedPrefs.setString(KEY_ID_TOKEN, credentials.idToken);
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