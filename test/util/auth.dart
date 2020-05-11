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
import 'package:stronk/redux/reducer/app_reducer.dart';
import 'package:test/test.dart';

void main() {
  MockSharedPreferences mockSharedPreferences;
  MockGoogleSignIn mockGoogleSignIn;
  MockFirebaseAuth mockFirebaseAuth;
  MockFirebaseUser mockFirebaseUser;
  MockGraphQLUtil mockGraphQLUtil;
  MockAuthResult mockAuthResult;
  MockStore mockStore;
  MockQueryResult mockQueryResult;

  AuthManager authManager;

  setUp(() {
    CONFIG = MockConfig();
    mockGraphQLUtil = MockGraphQLUtil();

    mockSharedPreferences = MockSharedPreferences();
    mockGoogleSignIn = MockGoogleSignIn();
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseUser = MockFirebaseUser();
    mockAuthResult = MockAuthResult();
    mockStore = MockStore();

    authManager = AuthManager(
        googleSignIn: mockGoogleSignIn,
        firebaseAuth: mockFirebaseAuth,
        sharedPrefs: mockSharedPreferences,
        store: mockStore);

    var mockClient = MockGraphQLClient();
    mockQueryResult = MockQueryResult();
    when(mockGraphQLUtil.client).thenReturn(mockClient);
    when(mockClient.mutate(any)).thenAnswer((_) async => mockQueryResult);
  });

  test("initialization creates dispatches a LoadingCompletedAction", () {
    verify(mockStore.dispatch(argThat(TypeMatcher<LoadingCompletedAction>()))).called(1);
  });

  test("successful sign in dispatches a LoginCompletedAction action", () async {
    var mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();
    when(mockGoogleSignInAuthentication.idToken).thenReturn("1");
    when(mockGoogleSignInAuthentication.accessToken).thenReturn("2");

    var mockGoogleSignInAccount = MockGoogleSignInAccount();
    when(mockGoogleSignInAccount.authentication).thenAnswer((_) async => mockGoogleSignInAuthentication);

    when(mockGoogleSignIn.signIn()).thenAnswer((_) async => mockGoogleSignInAccount);

    when(mockFirebaseAuth.signInWithCredential(any)).thenAnswer((_) async => mockAuthResult);
    when(mockAuthResult.user).thenReturn(mockFirebaseUser);
    when(mockFirebaseUser.getIdToken()).thenAnswer((_) async => MockIdTokenResult());

    // set up correct gql create account response
    var data = JsonDecoder().convert("""
      {
        "createUser": {
          "user": {
            "id": "test",
            "name": "richard wei",
            "username": "therichardwei",
            "email": "test@email.com"
          }
        }
      }
    """);
    when(mockQueryResult.hasException).thenReturn(false);
    when(mockQueryResult.data).thenReturn(data);

    await authManager.initialSignIn(mockGraphQLUtil);

    verify(mockStore.dispatch(argThat(TypeMatcher<LoginCompletedAction>()))).called(1);
  });

  test("failed sign in doesn't dispatch a LoginCompletedAction action", () async {
    var mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();
    when(mockGoogleSignInAuthentication.idToken).thenReturn("1");
    when(mockGoogleSignInAuthentication.accessToken).thenReturn("2");

    var mockGoogleSignInAccount = MockGoogleSignInAccount();
    when(mockGoogleSignInAccount.authentication).thenAnswer((_) async => mockGoogleSignInAuthentication);

    when(mockGoogleSignIn.signIn()).thenAnswer((_) async => mockGoogleSignInAccount);

    when(mockFirebaseAuth.signInWithCredential(any)).thenAnswer((_) async => mockAuthResult);
    when(mockAuthResult.user).thenReturn(mockFirebaseUser);
    when(mockFirebaseUser.getIdToken()).thenAnswer((_) async => MockIdTokenResult());

    // fill fail the sign in attempt
    when(mockQueryResult.hasException).thenReturn(true);
    await authManager.initialSignIn(mockGraphQLUtil);

    verifyNever(mockStore.dispatch(argThat(TypeMatcher<LoginCompletedAction>())));
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
