import 'package:stronk/domain/model/program.dart';
import 'package:stronk/domain/model/user.dart';
import 'package:stronk/redux/state/app_state.dart';

AppState appReducer(AppState state, dynamic action) {
  return new AppState(
    user : null,
    nav : state.nav,
    currentProgram: null,
  );
}

Navigation navigationReducer(nav, action) {
  return action.selected;
}

// region app actions

class ChangeNavigationItemAction {
  final Navigation selected;

  ChangeNavigationItemAction(this.selected);
}

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