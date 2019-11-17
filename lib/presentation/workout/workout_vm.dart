import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/redux/state/app_state.dart';

class WorkoutVM {
  final Store<AppState> store;
  final Workout workout;

  WorkoutVM({
    @required this.store,
    @required this.workout,
  });

  factory WorkoutVM.create(Store<AppState> store) {
    // TODO find the current workout
    final workout = Workout(id: "test");
//    final workout = store.state.currentProgram.workouts.first;

    return WorkoutVM(
        store : store,
        workout: workout,
    );
  }

}