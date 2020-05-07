import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphql/client.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stronk/api/graphql.dart';
import 'package:stronk/auth_manager.dart';
import 'package:stronk/config.dart';
import 'package:test/test.dart';

void main() {
  MockSharedPreferences mockSharedPreferences;
  MockGoogleSignIn mockGoogleSignIn;
  MockFirebaseAuth mockFirebaseAuth;
  MockFirebaseUser mockFirebaseUser;
  MockGraphQLUtil mockGraphQLUtil;
  MockAuthResult mockAuthResult;
  MockStore mockStore;

  AuthManager authManager;

  setUp(() {
    CONFIG = MockConfig();
    mockGraphQLUtil = MockGraphQLUtil();

    mockSharedPreferences = MockSharedPreferences();
    mockGoogleSignIn = MockGoogleSignIn();
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseUser = MockFirebaseUser();
    mockAuthResult = MockAuthResult();

    authManager =
        AuthManager(googleSignIn: mockGoogleSignIn, firebaseAuth: mockFirebaseAuth, sharedPrefs: mockSharedPreferences, store: null);

    var mockClient = MockGraphQLClient();
    var mockQueryResult = MockQueryResult();
    when(mockGraphQLUtil.temporaryClient(any)).thenReturn(mockClient);
    when(mockClient.mutate(any)).thenAnswer((_) async => mockQueryResult);

    var data = JsonDecoder().convert("""
      {
        "user" : {
          "name": "richard wei",
          "username": "therichardwei",
          "email": "test@email.com"
        }
      }
    """);

    when(mockQueryResult.hasException).thenReturn(false);
    when(mockQueryResult.data).thenReturn(data);
  });

  test("googleSignIn is called when there are no existing credentials", () async {
    when(mockSharedPreferences.getString(KEY_ACCESS_TOKEN)).thenReturn(null);
    when(mockSharedPreferences.getString(KEY_ID_TOKEN)).thenReturn(null);

    var mockGoogleSignInAccount = MockGoogleSignInAccount();
    var mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();

    when(mockGoogleSignInAuthentication.idToken).thenReturn("1");
    when(mockGoogleSignInAuthentication.accessToken).thenReturn("2");

    when(mockFirebaseAuth.signInWithCredential(any)).thenAnswer((_) async => mockAuthResult);
    when(mockAuthResult.user).thenReturn(mockFirebaseUser);
    when(mockFirebaseUser.getIdToken()).thenAnswer((_) async => MockIdTokenResult());

    when(mockGoogleSignIn.signIn()).thenAnswer((_) async => mockGoogleSignInAccount);
    when(mockGoogleSignInAccount.authentication).thenAnswer((_) async => mockGoogleSignInAuthentication);

    await authManager.handleSignIn(mockGraphQLUtil);
    verify(mockGoogleSignIn.signIn()).called(1);
  });

  test("googleSignIn is not called when there are existing credentials", () async {
    when(mockSharedPreferences.getString(KEY_ACCESS_TOKEN)).thenReturn("1");
    when(mockSharedPreferences.getString(KEY_ID_TOKEN)).thenReturn("2");

    when(mockFirebaseAuth.signInWithCredential(any)).thenAnswer((_) async => MockAuthResult());

    await authManager.handleSignIn(mockGraphQLUtil);
    verifyNever(mockGoogleSignIn.signIn());
  });
}

class MockConfig extends Mock implements Config {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGraphQLUtil extends Mock implements GraphQLUtility {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}

class MockAuthResult extends Mock implements AuthResult {}

class MockFirebaseUser extends Mock implements FirebaseUser {}

class MockIdTokenResult extends Mock implements IdTokenResult {}

class MockGraphQLClient extends Mock implements GraphQLClient {}

class MockQueryResult extends Mock implements QueryResult {}

class MockStore extends Mock implements Store {}