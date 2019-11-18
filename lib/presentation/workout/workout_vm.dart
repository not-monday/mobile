import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'package:stronk/domain/model/exercise.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/redux/state/app_state.dart';
import 'package:bloc/bloc.dart';
import 'dart:async';

import 'package:stronk/repository/program_repo.dart';

enum WorkoutEvent {
  Init
}
//class workoutActions extends WorkoutAction {}

class WorkoutState {
  final Workout workout;

  WorkoutState(this.workout);
}

class WorkoutVM extends Bloc<WorkoutEvent, WorkoutState>{
  final Workout workout;
  final ProgramRepository programRepo;

  WorkoutVM({
    @required this.workout,
    @required this.programRepo,
  }) {
    add(WorkoutEvent.Init);
  }

  factory WorkoutVM.create(Store<AppState> store) {
    // TODO find the current workout
    final exercises = [Exercise(id: "test"), Exercise(id: "test"), Exercise(id: "test")];
    final workout = Workout(id: "test", exercises: exercises);
    // TODO convert this to di
    final programRepo = ProgramRepository();

    return WorkoutVM(
        workout: workout,
        programRepo : programRepo,
    );
  }

  @override
  // TODO: implement initialState
  WorkoutState get initialState => WorkoutState(workout);

  @override
  Stream<WorkoutState> mapEventToState(WorkoutEvent event) async* {
    switch(event) {
      case WorkoutEvent.Init:
        final workout = await programRepo.retrieveWorkout();
        yield WorkoutState(workout);
        break;
    }
  }

}