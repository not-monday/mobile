
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/repository/program_repo.dart';

enum ActiveWorkoutEvent {
  Init, CompleteSet, FailSet
}

class ActiveWorkoutState {
  bool loading;
  bool completed = false;
  WorkoutExercise currentExercise;
  ExerciseSet currentSet;

  List<WorkoutExercise> exercises;

  ActiveWorkoutState({
    this.loading = false,
    @required this.currentExercise,
    @required this.currentSet,
    @required List<WorkoutExercise> exercises
  });
}

class ActiveWorkoutVM extends Bloc<ActiveWorkoutEvent, ActiveWorkoutState>{
  final ProgramRepository programRepo;

  int currentExerciseIndex;
  int currentSetIndex;

  ActiveWorkoutVM({
    @required this.programRepo
  }) {
    add(ActiveWorkoutEvent.Init);
  }

  @override
  ActiveWorkoutState get initialState => ActiveWorkoutState(
    loading: true,
    currentExercise: null,
    currentSet: null,
    exercises: List(),
  );

  @override
  Stream<ActiveWorkoutState> mapEventToState(ActiveWorkoutEvent event) async* {
    print(event.toString());
    switch(event) {
      case ActiveWorkoutEvent.Init:
        yield await _handleInitialize();
        break;
      case ActiveWorkoutEvent.CompleteSet:
        yield await _handleCompleteSet(true);
        break;
      case ActiveWorkoutEvent.FailSet:
        yield await _handleCompleteSet(false);
        break;
    }
  }

  Future<ActiveWorkoutState> _handleInitialize() async{
    final workout = await programRepo.retrieveWorkout();
    final exercises = workout.workoutExercises;

    WorkoutExercise currentExercise;
    ExerciseSet currentSet;

    if (exercises.isNotEmpty) {
      currentExercise = exercises.first;
    }
    if (currentExercise != null && currentExercise.exerciseSets.isNotEmpty)  {
      currentSet = currentExercise.exerciseSets.first;
    }

    return ActiveWorkoutState(
      currentExercise: currentExercise,
      currentSet: currentSet,
      exercises: exercises,
    );
  }

  Future<ActiveWorkoutState> _handleCompleteSet(bool success) async{
    // TODO request to update the exercise or add it to request queue

    state.currentSet.completed = true;
    if (currentSetIndex == state.currentExercise.exerciseSets.length - 1) {
      // complete the current exercise
      state.currentExercise.completed = true;
      currentExerciseIndex += 1;
      currentSetIndex = 0;
    } else {
      currentSetIndex += 1;
    }

    if (currentExerciseIndex == state.exercises.length) {
      // update state to reflect all exercises have been completed
      state.completed = true;
    } else {
      state.currentExercise = state.exercises[currentSetIndex];
    }

    return state;
  }

}