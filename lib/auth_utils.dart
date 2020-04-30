import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

// initialize google signin and firebase auth instances
final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

/*
utilities dealing with authentication
 */
class AuthManager {
  SharedPreferences prefs = null;
  Account currentAccount = null;
  FirebaseUser currentUser = null;

  handleSignIn() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    // first try to get current account info from shared pref
    getCurrentCredentials().then((existingCredentials) async {
      var credentials = existingCredentials;

      // user hasn't logged in on the app
      if (existingCredentials == null) {
        // interactive sign 
        var googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser.authentication;
        // store credentials locally for later use
        credentials = Credentials(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        setCurrentCredentials(credentials);
      }

      // build auth provider credentials to sign in
      var googleCredentials = GoogleAuthProvider.getCredential(
        accessToken: credentials.accessToken,
        idToken: credentials.idToken,
      );

      currentUser = (await _auth.signInWithCredential(googleCredentials)).user;
    });
  }

  Future<Credentials> getCurrentCredentials() async {
    final accessToken =  prefs.getString(KEY_ACCESS_TOKEN);
    final idToken =  prefs.getString(KEY_ID_TOKEN);

    if (accessToken == null || idToken == null) return null;
    return Credentials(accessToken: accessToken, idToken: idToken);
  }

  Future<Credentials> setCurrentCredentials(Credentials credentials) async {
    prefs.setString(KEY_ACCESS_TOKEN, credentials.accessToken);
    prefs.setString(KEY_ID_TOKEN, credentials.idToken);
  }
}

const KEY_ACCESS_TOKEN = "account.uid";
const KEY_ID_TOKEN = "account.uid";

class Credentials {
  String accessToken;
  String idToken;
  Credentials({this.accessToken, this.idToken});
}

class Account {
  String uid, displayName, photoUrl, email, phoneNumber,token;
  Account({
    this.uid,
    this.displayName,
    this.photoUrl,
    this.email,
    this.phoneNumber,
    this.token
  });
}