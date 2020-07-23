import 'dart:core';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/domain/model/record.dart';
import 'package:stronk/domain/model/workout.dart';

class ActiveWorkoutState {
  final Workout workoutRef;
  final List<ExerciseRecord> exerciseRecords;
  final List<List<SetRecord>> setRecords;
  final int currentExerciseIndex;
  final int currentSetIndex;
  final int remainingExerciseCount;
  final int completedExerciseCount;
  final bool completed;

  ActiveWorkoutState(
      {@required this.workoutRef,
      @required this.exerciseRecords,
      @required this.setRecords,
      @required this.currentExerciseIndex,
      @required this.currentSetIndex,
      @required this.remainingExerciseCount,
      @required this.completedExerciseCount,
      @required this.completed});

  @override
  String toString() {
    return ("\nworkoutRef: $workoutRef\n"
        "exerciseRecords: $exerciseRecords\n"
        "setRecords: $setRecords\n"
        "currentExerciseIndex: $currentExerciseIndex\n"
        "currentSetIndex: $currentSetIndex\n"
        "completed: $completed\n");
  }
}

// region events
@sealed
abstract class _Event {}

class InitEvent implements _Event {}

class CompleteExerciseEvent implements _Event {}

class FailExerciseEvent implements _Event {
  int repsBeforeFailure;

  FailExerciseEvent(this.repsBeforeFailure);
}
// endregion region events

class ActiveWorkoutBloc extends Bloc<_Event, ActiveWorkoutState> {
  final WorkoutRepository workoutRepo;

  @override
  ActiveWorkoutState get initialState => new ActiveWorkoutState(
      workoutRef: null,
      exerciseRecords: [],
      setRecords: [],
      currentExerciseIndex: 0,
      currentSetIndex: 0,
      remainingExerciseCount: 0,
      completedExerciseCount: 0,
      completed: false);

  @override
  Stream<ActiveWorkoutState> mapEventToState(_Event event) async* {
    var newState = state;
    if (event is InitEvent) {
      newState = await handleInit().catchError((error) => print(error));
    } else if (event is CompleteExerciseEvent) {
      newState = await handleCompleteExercise().catchError((error) => print(error));
    } else if (event is FailExerciseEvent) {
      newState = await handleFailExercise(event.repsBeforeFailure).catchError((error) => print(error));
    }

    yield newState;
  }

  ActiveWorkoutBloc({@required this.workoutRepo}) {
    add(new InitEvent());
  }

  // region event handlers
  Future<ActiveWorkoutState> handleInit() async {
    final activeWorkout = await workoutRepo.mockRetrieveWorkout();

    final exerciseRecords = activeWorkout.workoutExercises
        .map((exercise) => new ExerciseRecord(status: Status.Incomplete, exercise: exercise))
        .toList();

    // create set record for each exercise set
    final setRecords = activeWorkout.workoutExercises
        .map((exercise) => exercise.exerciseSets
            .map((exerciseSet) =>
                new SetRecord(status: Status.Incomplete, repsBeforeFailure: null, exerciseSet: exerciseSet))
            .toList())
        .toList();

    return new ActiveWorkoutState(
      workoutRef: activeWorkout,
      exerciseRecords: exerciseRecords,
      setRecords: setRecords,
      currentSetIndex: state.currentSetIndex,
      currentExerciseIndex: state.currentExerciseIndex,
      remainingExerciseCount: activeWorkout.workoutExercises.length,
      completedExerciseCount: 0,
      completed: state.completed,
    );
  }

  Future<ActiveWorkoutState> handleCompleteExercise() async => _updateExerciseRecord(Status.Passed, null);

  Future<ActiveWorkoutState> handleFailExercise(int repsBeforeFailure) async {
    log("reps before failure $repsBeforeFailure");
    //TODO send failure to server
    return _updateExerciseRecord(Status.Failed, repsBeforeFailure);
  }

  // endregion event handlers

  ActiveWorkoutState _updateExerciseRecord(Status status, int repsBeforeFailure) {
    if (state.workoutRef == null) return null;

    final setRecords = state.setRecords[state.currentExerciseIndex];

    // update set record with new status
    final currSetRecord = setRecords[state.currentSetIndex];
    final newSetRecord =
        new SetRecord(status: status, repsBeforeFailure: repsBeforeFailure, exerciseSet: currSetRecord);

    final newExerciseSetRecords = [...setRecords];
    newExerciseSetRecords[state.currentSetIndex] = newSetRecord;
    final newSetRecords = [...state.setRecords];
    newSetRecords[state.currentExerciseIndex] = newExerciseSetRecords;

    var newSetIndex = state.currentSetIndex + 1;
    var newExerciseRecords = state.exerciseRecords;
    var newExerciseIndex = state.currentExerciseIndex;
    var completedWorkout = state.completed;
    var remainingCount = state.remainingExerciseCount;
    var completedCount = state.completedExerciseCount;

    // update the index of the current exercise if it has no more sets
    if (state.currentSetIndex == newSetRecords.length - 1) {
      // update the exercises to reflect the completion of current exercise
      final currExerciseRecord = state.exerciseRecords[state.currentExerciseIndex];
      newExerciseRecords = [...state.exerciseRecords];
      newExerciseRecords[state.currentExerciseIndex] =
          new ExerciseRecord(exercise: currExerciseRecord, status: Status.Passed);

      newSetIndex = 0;
      newExerciseIndex = state.currentExerciseIndex + 1;

      if (newExerciseIndex == state.exerciseRecords.length) {
        // complete workout if all exercises have been completed
        completedWorkout = true;
      }

      remainingCount -= 1;
      completedCount += 1;
    }

    return ActiveWorkoutState(
        workoutRef: state.workoutRef,
        currentSetIndex: newSetIndex,
        currentExerciseIndex: newExerciseIndex,
        exerciseRecords: newExerciseRecords,
        setRecords: newSetRecords,
        remainingExerciseCount: remainingCount,
        completedExerciseCount: completedCount,
        completed: completedWorkout);
  }
}
