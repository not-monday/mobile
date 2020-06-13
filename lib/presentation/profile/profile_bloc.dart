import 'package:stronk/domain/model/user.dart';
import 'package:meta/meta.dart';
import 'package:stronk/api/user_repo.dart';
import 'package:bloc/bloc.dart';

class ProfileState {

  final User user;

  ProfileState({this.user});

  @override
  String toString() {
    return ("\n name: $user");
  }
}

@sealed
abstract class _Event {}

class InitEvent implements _Event {}


class ProfileBloc extends Bloc<_Event, ProfileState> {
  final UserRepository userRepository;

  @override
  ProfileState get initialState => new ProfileState(user: null);

  @override
  Stream<ProfileState> mapEventToState(_Event event) async* {
    var newState = state;
    if (event is InitEvent) {
      newState = await handleInit();
    }
    yield newState;
  }

  ProfileBloc({@required this.userRepository}) {
    add(new InitEvent());
  }

  Future<ProfileState> handleInit() async {
    final user = await userRepository.retrieveUser();
    return new ProfileState(user: user);
  }
}
