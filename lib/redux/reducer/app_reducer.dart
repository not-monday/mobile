import 'package:flutter/foundation.dart';
import 'package:stronk/auth_manager.dart';
import 'package:stronk/domain/model/user.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/redux/state/app_state.dart';

/// TODO file too disorganized - extract reducers and actions into different files

AppState appReducer(AppState state, dynamic action) {
  // todo extract into different reducers
  print(state.user);
  print(state.currentProgram);
  return AppState(
    screenState: screenStateReducer(state.screenState, action),
    user: userReducer(state.user, action),
    currentProgram: programReducer(state.currentProgram, action),
    account: accountReducer(state.account, action)
  );
}

ScreenState screenStateReducer(ScreenState screenState, dynamic action) {
  switch (action.runtimeType) {
    case LoadingCompletedAction:
      return (action.currentAccount == null)? ScreenState.LoginRequired : ScreenState.Ready;
    case LoginCompletedAction:
      return ScreenState.Ready;
    default:
      return screenState;
  }
}

Account accountReducer(Account account, dynamic action) {
  switch (action.runtimeType) {
    case LoadingCompletedAction:
      return action.currentAccount ;
    case LoginCompletedAction:
      return action.currentAccount;
    default:
      return account;
  }
}

User userReducer(User user, dynamic action) {
  if (action is UserRetrievedAction) {
    return action.retrievedUser;
  } else {
    return user;
  }
}

Program programReducer(Program program, dynamic action) {
  if (action is ProgramRetrievedAction) {
    return action.retrievedProgram;
  }
  else {
    return program;
  }
}

// region app actions

class LoadingCompletedAction {
  Account currentAccount;

  LoadingCompletedAction({
     @required this.currentAccount
  });
}

class LoginCompletedAction {
  Account currentAccount;

  LoginCompletedAction({
    @required this.currentAccount
  });
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

class RetrieveWorkoutAction {}

class WorkoutRetrievedAction {
  Workout retrievedWorkout;

  WorkoutRetrievedAction(this.retrievedWorkout);
}

class UserSignedInAction {

}
// endregion app actions