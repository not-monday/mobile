import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/repository/program_repo.dart';

enum WorkoutEvent {
  Init
}

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