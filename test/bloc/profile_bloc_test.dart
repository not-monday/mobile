import 'package:mockito/mockito.dart';
import 'package:stronk/api/graphql.dart';
import 'package:stronk/api/graphql/userDocument.dart';
import 'package:stronk/api/user_repo.dart';
import 'package:stronk/auth_manager.dart';
import 'package:stronk/presentation/profile/profile_bloc.dart';
import 'package:test/test.dart';

class MockUserRepo extends Mock implements UserRepository {}

class MockAuthManager extends Mock implements AuthManager {}

class MockGraphQLUtility extends Mock implements GraphQLUtility {}

class MockUserPageModel extends Mock implements UserPageModel {}


void main() {
  ProfileBloc profileBloc;
  UserRepository mockUserRepo;
  AuthManager authManager;
  GraphQLUtility graphQLUtility;
  Account mockAccount;
  UserPageModel mockUserPageModel;

  setUp(() {
    mockUserRepo = MockUserRepo();
    authManager = MockAuthManager();
    graphQLUtility = MockGraphQLUtility();
    mockUserPageModel = UserPageModel(user: UserRepositoryImpl.mockUser());
    profileBloc =
        ProfileBloc(userRepository: mockUserRepo, authManager: authManager, graphQLUtility: graphQLUtility);
    mockAccount = new Account(
        id: "1",
        credentials: null,
        name: "test",
        email: "test@flutter.ca",
        username: null);
  });

  tearDown(() {
    profileBloc.close();
  });

  test("Initialize User", () async {
    when(authManager.currentAccount).thenReturn(mockAccount);
    when(graphQLUtility.makePageRequest<UserPageModel>(any, any)).thenAnswer((_) async => Future.value(mockUserPageModel));
    var mockUser = UserRepositoryImpl.mockUser();

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
          matcher.having((state) => state.user, "initialized user", mockUserPageModel.user),
        ])).then((_) => matchEndState);
    profileBloc.add(new InitEvent());
  });
}
