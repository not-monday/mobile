

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stronk/auth_manager.dart';
import 'package:test/test.dart';

void main() {
  MockSharedPreferences mockSharedPreferences;
  MockGoogleSignIn mockGoogleSignIn;
  MockFirebaseAuth mockFirebaseAuth;

  AuthManager authManager;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockGoogleSignIn = MockGoogleSignIn();
    mockFirebaseAuth = MockFirebaseAuth();

    authManager = AuthManager(googleSignIn: mockGoogleSignIn, firebaseAuth: mockFirebaseAuth, sharedPrefs: mockSharedPreferences);
  });

  test("googleSignIn is called when there are no existing credentials", () async {
    when(mockSharedPreferences.getString(KEY_ACCESS_TOKEN)).thenReturn(null);
    when(mockSharedPreferences.getString(KEY_ID_TOKEN)).thenReturn(null);

    var mockGoogleSignInAccount = MockGoogleSignInAccount();
    var mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();

    when(mockGoogleSignInAuthentication.idToken).thenReturn("1");
    when(mockGoogleSignInAuthentication.accessToken).thenReturn("2");

    when(mockFirebaseAuth.signInWithCredential(any)).thenAnswer((_) async => MockAuthResult());

    when(mockGoogleSignIn.signIn()).thenAnswer((_) async => mockGoogleSignInAccount);
    when(mockGoogleSignInAccount.authentication).thenAnswer((_) async => mockGoogleSignInAuthentication);

    await authManager.handleSignIn();
    verify(mockGoogleSignIn.signIn()).called(1);
  });

  test("googleSignIn is not called when there are existing credentials", () async {
    when(mockSharedPreferences.getString(KEY_ACCESS_TOKEN)).thenReturn("1");
    when(mockSharedPreferences.getString(KEY_ID_TOKEN)).thenReturn("2");

    when(mockFirebaseAuth.signInWithCredential(any)).thenAnswer((_) async => MockAuthResult());

    await authManager.handleSignIn();
    verifyNever(mockGoogleSignIn.signIn());
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
class MockGoogleSignIn extends Mock implements GoogleSignIn {}
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}
class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}
class MockAuthResult extends Mock implements AuthResult {}