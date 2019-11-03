import 'package:stronk/domain/model/program.dart';
import 'package:stronk/domain/model/user.dart';
import 'package:stronk/redux/state/app_state.dart';

AppState appReducer(AppState state, dynamic action) {
  // todo extract into different reducers
  print(state.user);
  print(state.currentProgram);
  return AppState(
      user: userReducer(state.user, action),
      currentProgram: programReducer(state.currentProgram, action)
  );
}

User userReducer(User user, dynamic action) {
  if (action is UserRetrievedAction) {
//    print(action.retrievedUser);
    return action.retrievedUser;
  } else {
    return user;
  }
}

Program programReducer(Program program, dynamic action) {
  if (action is ProgramRetrievedAction) {
//    print(action.retrievedProgram);
    return action.retrievedProgram;
  } else {
    return program;
  }
}

// region app actions

class UpdateCurrentUserAction {}

class RetrieveProgramAction {}

class ProgramRetrievedAction {
  Program retrievedProgram;
  ProgramRetrievedAction(this.retrievedProgram);
}

class RetrieveUserAction {}

class UserRetrievedAction {
  User retrievedUser;
  UserRetrievedAction(this.retrievedUser);
}
// endregion app actions