import 'package:mockito/mockito.dart';
import 'package:stronk/api/user_repo.dart';
import 'package:stronk/auth_manager.dart';
import 'package:stronk/presentation/profile/profile_bloc.dart';
import 'package:test/test.dart';

class MockUserRepo extends Mock implements UserRepository {}

class MockAuthManager extends Mock implements AuthManager {}

void main() {
  ProfileBloc profileBloc;
  UserRepository mockUserRepo;
  AuthManager authManager;

  setUp(() {
    mockUserRepo = MockUserRepo();
    authManager = MockAuthManager();
    profileBloc =
        ProfileBloc(userRepository: mockUserRepo, authManager: authManager);
  });

  tearDown(() {
    profileBloc.close();
  });

  test("Initialize User", () async {
    when(authManager.currentAccount).thenReturn(new Account(
        id: "1",
        credentials: null,
        name: "test",
        email: "test@flutter.ca",
        username: null));

    var mockUser = UserRepositoryImpl.mockUser();
    when(mockUserRepo.retrieveUserById(any))
        .thenAnswer((_) => Future.value(mockUser));

    var matcher = TypeMatcher<ProfileState>();
    var matchEndState = (_) {
      var user = profileBloc.state.user;
      expect(user, mockUser);
    };

    expectLater(
        profileBloc,
        emitsInOrder([
          matcher.having(
              (state) => state.user, "initially no user details", null),
          matcher.having((state) => state.user, "initialized user", mockUser),
        ])).then((_) => matchEndState);
    profileBloc.add(new InitEvent());
  });
}
