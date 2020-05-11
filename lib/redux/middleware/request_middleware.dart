import 'package:redux/redux.dart';
import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/domain/model/user.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/redux/reducer/app_reducer.dart';
import 'package:stronk/redux/state/app_state.dart';
import 'package:stronk/api/user_repo.dart';

class RequestMiddleware extends MiddlewareClass<AppState> {
  UserRepositoryImpl userRepo;
  WorkoutRepository workoutRepo;

  RequestMiddleware(this.userRepo, this.workoutRepo);

  @override
  void call(Store store, action, NextDispatcher next) async {

    if (action is RetrieveProgramAction) {
      _retrieveProgram(store, next);
    } else if (action is RetrieveUserAction) {
      _retrieveUser(store, next);
    } if (action is RetrieveWorkoutAction) {
      _retrieveWorkout(store, next);
    } else {
      print("$action action passed through request middleware");
      next(action);
    }
  }

  _retrieveUser(Store<AppState> store, NextDispatcher next) async {
    userRepo.retrieveUser().then((User user) => {
      next(UserRetrievedAction(user))
    });
  }

  _retrieveProgram(Store store, NextDispatcher next) {
    workoutRepo.retrieveProgram().then((Program program) => {
      next(ProgramRetrievedAction(program))
    });
  }

  _retrieveWorkout(Store store, NextDispatcher next) {
    // programRepo.retrieveWorkout().then((Workout workout ) => {
    //   next(WorkoutRetrievedAction(workout))
    // });
  }

}