import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stronk/api/graphql.dart';
import 'package:stronk/api/graphql/userDocument.dart';
import 'package:stronk/api/user_repo.dart';
import 'package:stronk/domain/model/user.dart';

import '../../auth_manager.dart';

class ProfileState {

  final User user;


  ProfileState({@required this.user});

  @override
  String toString() {
    return ("\n $user");
  }
}

@sealed
abstract class _Event {}

class InitEvent implements _Event {}


class ProfileBloc extends Bloc<_Event, ProfileState> {
  final UserRepository userRepository;
  final AuthManager authManager;
  final GraphQLUtility graphQLUtility;

  @override
  ProfileState get initialState => new ProfileState(user : null);

  @override
  Stream<ProfileState> mapEventToState(_Event event) async* {
    var newState = state;
    if (event is InitEvent) {
      newState = await handleInit();
    }
    yield newState;
  }

  ProfileBloc({@required this.userRepository, this.authManager, this.graphQLUtility}) {
    add(new InitEvent());
  }

  Future<ProfileState> handleInit() async {
    final userDetails = await graphQLUtility.makePageRequest<UserPageModel>(
        UserDocument.queryUser(authManager.currentAccount.id),
            (json) => UserPageModel.fromJson(json)
    );
    return new ProfileState(user: userDetails.user);
  }
}
