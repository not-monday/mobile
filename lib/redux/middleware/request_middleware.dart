import 'package:redux/redux.dart';
import 'package:stronk/domain/model/program.dart';
import 'package:stronk/domain/model/user.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/redux/reducer/app_reducer.dart';
import 'package:stronk/redux/state/app_state.dart';
import 'package:stronk/repository/program_repo.dart';
import 'package:stronk/repository/user_repo.dart';

class RequestMiddleware extends MiddlewareClass<AppState> {
  UserRepo userRepo;
  ProgramRepository programRepo;

  RequestMiddleware(this.userRepo, this.programRepo);

  @override
  void call(Store store, action, NextDispatcher next) async {

    if (action is RetrieveProgramAction) {
      _retrieveProgram(store, next);
    } else if (action is RetrieveUserAction) {
      _retrieveUser(store, next);
    } if (action is RetrieveWorkoutAction) {
      _retrieveWorkout(store, next);
    } else {
      print("action not passed through " + action.toString());
      next(action);
    }
  }

  _retrieveUser(Store<AppState> store, NextDispatcher next) async {
    userRepo.retrieveUser().then((User user) => {
      next(UserRetrievedAction(user))
    });
  }

  _retrieveProgram(Store store, NextDispatcher next) {
    programRepo.retrieveProgram().then((Program program) => {
      next(ProgramRetrievedAction(program))
    });
  }

  _retrieveWorkout(Store store, NextDispatcher next) {
    programRepo.retrieveWorkout().then((Workout workout ) => {
      next(WorkoutRetrievedAction(workout))
    });
  }

}