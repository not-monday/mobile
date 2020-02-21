import 'dart:core';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
  final bool completed;

  ActiveWorkoutState(
    {
      @required this.workoutRef,
      @required this.exerciseRecords,
      @required this.setRecords,
      @required this.currentExerciseIndex,
      @required this.currentSetIndex,
      @required this.completed
    });
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
    completed : false
  );

  @override
  Stream<ActiveWorkoutState> mapEventToState(_Event event) async* {
    var newState = state;
    if (event is InitEvent) {
      newState = await init();
    } else if (event is CompleteExerciseEvent) {
      newState = await completeExercise();
    } else if (event is FailExerciseEvent) {
      newState = await failExercise(event.repsBeforeFailure);
    }

    yield newState;
  }

  ActiveWorkoutBloc({@required this.workoutRepo}) {
    add(new InitEvent());
  }

  // region event handlers
  Future<ActiveWorkoutState> init() async {
    final activeWorkout = await workoutRepo.retrieveWorkout();

    final exerciseRecords = activeWorkout.workoutExercises.map(
      (exercise)=> new ExerciseRecord (
        status : Status.Incomplete, 
        exercise: exercise
      )).toList();
    
    final setRecords = activeWorkout.workoutExercises.map(
      // create set record for each exercise set
      (exercise)=> exercise.exerciseSets.map(
        (exerciseSet)=> new SetRecord(
          status : Status.Incomplete,
          repsBeforeFailure: null,
          exerciseSet: exerciseSet
        )
      ));

    return new ActiveWorkoutState(
      workoutRef: activeWorkout,
      exerciseRecords: exerciseRecords,
      setRecords: setRecords,
      currentSetIndex: state.currentSetIndex,
      currentExerciseIndex : state.currentExerciseIndex,
      completed: state.completed
    );
  }

  Future<ActiveWorkoutState> completeExercise() async => _updateExerciseRecord(Status.Passed, null);
  
  Future<ActiveWorkoutState> failExercise(int repsBeforeFailure) async  {
    log("reps before failure $repsBeforeFailure");
    //TODO send failure to server
    return _updateExerciseRecord(Status.Failed, repsBeforeFailure);
  } 
  // endregion event handlers

  ActiveWorkoutState _updateExerciseRecord(Status status, int repsBeforeFailure) {
    log("complete exercise ${state.currentExerciseIndex} ${state.currentSetIndex}");
    if (state.workoutRef == null) return null;

    final setRecords = state.setRecords[state.currentExerciseIndex];

    // update set record with new status
    final currSetRecord = setRecords[state.currentSetIndex];
    final newSetRecord = new SetRecord(
      status : currSetRecord.status,
      repsBeforeFailure : currSetRecord.repsBeforeFailure, 
      exerciseSet: currSetRecord
    ); 

    final newExerciseSetRecords = [...setRecords];
    newExerciseSetRecords[state.currentSetIndex] = newSetRecord;
    final newSetRecords = [...state.setRecords];
    newSetRecords[state.currentExerciseIndex] = newExerciseSetRecords;

    var newSetIndex = state.currentSetIndex + 1;
    var newExerciseRecords = state.exerciseRecords;
    var newExerciseIndex = state.currentExerciseIndex;
    var completedWorkout = state.completed;

    // update the index of the current exercise if it has no more sets
    if (state.currentSetIndex == newSetRecords.length - 1) {
    // update the exercises to reflect the completion of current exercise
    final currExerciseRecord = state.exerciseRecords[state.currentExerciseIndex];
    newExerciseRecords = [...state.exerciseRecords];
    newExerciseRecords[state.currentExerciseIndex] = new ExerciseRecord(exercise: currExerciseRecord, status: Status.Passed);

    newSetIndex = 0;
    newExerciseIndex = state.currentExerciseIndex + 1;

      if (state.currentExerciseIndex == state.setRecords.length) {
        // complete workout if all exercises have been completed
        completedWorkout = true;
      }
    }

    final newState = new ActiveWorkoutState(
      workoutRef: state.workoutRef,
      currentSetIndex: newSetIndex,
      currentExerciseIndex : newExerciseIndex,
      exerciseRecords: newExerciseRecords,
      setRecords: newSetRecords,
      completed: completedWorkout
    );

    log("{newState}");

    return newState;
  }
}