import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/domain/constants.dart' as Constants;
import 'package:stronk/domain/model/workout.dart';

import 'param_container.dart';

class WorkoutActionState {
  final Program programRef;
  final List<Workout> workoutRef;

  WorkoutActionState({@required this.programRef, this.workoutRef});

  @override
  String toString() {
    return ("\n programRef: $programRef\n"
        "workoutRef: $workoutRef");
  }
}

@sealed
abstract class _Event {}

class InitEvent implements _Event {}

class AddWorkoutEvent implements _Event {
  Workout workout;
  AddWorkoutEvent({this.workout});
}


class DeleteWorkoutEvent implements _Event {
  String workoutId;

  DeleteWorkoutEvent({this.workoutId});
}

class DeleteWorkoutExerciseEvent implements _Event {
  String workoutId;
  String workoutExerciseId;

  DeleteWorkoutExerciseEvent({this.workoutId, this.workoutExerciseId});
}

class EditWorkoutEvent implements _Event {
  String workoutId;
  String editAction;
  String newValue;

  EditWorkoutEvent({this.workoutId, this.editAction, this.newValue});
}

class EditWorkoutExerciseSetsRepsEvent implements _Event {
  ParamContainer paramContainer;
  int index;

  EditWorkoutExerciseSetsRepsEvent(this.paramContainer, this.index);
}

class EditProgramNameEvent implements _Event {
  // Once the schema supports more than one program
  //String programId;
  String newName;

  EditProgramNameEvent(this.newName);
}

class SetsAndRepsEvent implements _Event {
  ParamContainer params;

  SetsAndRepsEvent({this.params});
}

class WorkoutActionBloc extends Bloc<_Event, WorkoutActionState> {
  final WorkoutRepository workoutRepo;

  @override
  WorkoutActionState get initialState =>
      new WorkoutActionState(programRef: null);

  @override
  Stream<WorkoutActionState> mapEventToState(_Event event) async* {
    var newState = state;
    try {
      if (event is InitEvent) {
        newState = await handleInit();
      } else if (event is EditProgramNameEvent) {
        newState = await handleEditProgramName(event.newName);
      } else if (event is EditWorkoutEvent) {
        newState = await handleEditWorkout(
            event.workoutId, event.editAction, event.newValue);
      } else if (event is DeleteWorkoutEvent) {
        newState = await handleDeleteWorkout(event.workoutId);
      } else if (event is DeleteWorkoutExerciseEvent) {
        newState = await handleDeleteWorkoutExerciseEvent(
            event.workoutId, event.workoutExerciseId);
      } else if (event is SetsAndRepsEvent) {
        newState = await handleSetsAndRepsEvent(event.params);
      } else if (event is AddWorkoutEvent) {
        newState = await handleAddWorkout(event.workout);
      }
    } catch (error) {
      print(error);
    }

    yield newState;
  }

  WorkoutActionBloc({@required this.workoutRepo}) {
    add(new InitEvent());
  }

  Future<WorkoutActionState> handleInit() async {
    final activeWorkout = await workoutRepo.retrieveProgram();

    return WorkoutActionState(
        programRef: activeWorkout, workoutRef: activeWorkout.workouts);
  }

  Future<WorkoutActionState> handleEditProgramName(String newName) async {
    if (state.programRef == null) {
      return null;
    }

    final editedProgram =
        new Program(name: newName, workouts: state.programRef.workouts);
    return WorkoutActionState(
        programRef: editedProgram, workoutRef: editedProgram.workouts);
  }

  Future<WorkoutActionState> handleEditWorkout(
      String workoutId, String action, String newValue) async {
    if (state.programRef == null) {
      return null;
    } else if (state.workoutRef == []) {
      return state;
    }
    List<Workout> workouts;
    Workout editedWorkout;

    Workout targetWorkout =
        state.workoutRef.singleWhere((workout) => workout.id == workoutId);
    workouts =
        state.workoutRef.where((workout) => workout.id != workoutId).toList();
    final indexOfTargetWorkout = state.workoutRef.indexOf(targetWorkout);

    switch (action) {
      case Constants.EDIT_WORKOUT_DESCRIPTION:
        {
          editedWorkout = new Workout(
              name: targetWorkout.name,
              id: targetWorkout.id,
              description: newValue,
              workoutExercises: targetWorkout.workoutExercises);
        }
        break;
      case Constants.EDIT_WORKOUT_NAME:
        {
          editedWorkout = new Workout(
              id: workoutId,
              name: newValue,
              description: targetWorkout.description,
              workoutExercises: targetWorkout.workoutExercises);
        }
        break;
    }
    workouts.insert(indexOfTargetWorkout, editedWorkout);
    final updatedProgram =
        new Program(name: state.programRef.name, workouts: workouts);

    return WorkoutActionState(
        programRef: updatedProgram, workoutRef: updatedProgram.workouts);
  }

  Future<WorkoutActionState> handleDeleteWorkout(String id) async {
    if (state.programRef == null) {
      return null;
    } else if (state.workoutRef == []) {
      return state;
    }
    List<Workout> workouts;
    workouts = state.workoutRef.where((workout) => workout.id != id).toList();
    final updatedProgram =
        new Program(name: state.programRef.name, workouts: workouts);
    return WorkoutActionState(programRef: updatedProgram, workoutRef: workouts);
  }

  Future<WorkoutActionState> handleAddWorkout(Workout workout) async {
    if (state.programRef == null) {
      return null;
    }
    List<Workout> workouts;
    workouts = state.workoutRef;
    workouts.add(workout);

    final updatedProgram =
        new Program(name: state.programRef.name, workouts: workouts);
    return WorkoutActionState(
        programRef: updatedProgram, workoutRef: updatedProgram.workouts);
  }

  Future<WorkoutActionState> handleDeleteWorkoutExerciseEvent(
      String workoutId, String workoutExerciseId) async {
    if (state.programRef == null) {
      return null;
    } else if (state.workoutRef == []) {
      return state;
    }

    final workoutRef = state.workoutRef;

    List<Workout> workouts;
    List<WorkoutExercise> workoutExercises;
    Workout editWorkout;

    workouts = workoutRef.where((workout) => workout.id != workoutId).toList();
    editWorkout = workoutRef.singleWhere((workout) => workout.id == workoutId);
    workoutExercises = editWorkout.workoutExercises
        .where((workoutExercise) => workoutExercise.id != workoutExerciseId)
        .toList();

    final indexOfEditWorkout = state.workoutRef.indexOf(editWorkout);

    editWorkout = new Workout(
        id: editWorkout.id,
        name: editWorkout.name,
        workoutExercises: workoutExercises,
        description: editWorkout.description);
    workouts.insert(indexOfEditWorkout, editWorkout);
    final updatedProgram =
        new Program(name: state.programRef.name, workouts: workouts);
    return WorkoutActionState(programRef: updatedProgram, workoutRef: workouts);
  }

  Future<WorkoutActionState> handleSetsAndRepsEvent(
      ParamContainer params) async {
    final programRef = state.programRef;
    final workoutRef = state.workoutRef;
    final editWorkoutId = params.workoutId;
    final editWorkoutExerciseId = params.workoutExerciseId;
    final action = params.action;

    // Editing the workout list, requires mutation
    Program editProgram;
    Workout editWorkout;
    WorkoutExercise editWorkoutExercise;
    List<Workout> workouts;
    List<WorkoutExercise> workoutExercises;
    List<ExerciseSet> exerciseSets;

    workouts =
        workoutRef.where((workout) => workout.id != editWorkoutId).toList();

    editWorkout =
        workoutRef.singleWhere((workout) => workout.id == editWorkoutId);

    editWorkoutExercise = editWorkout.workoutExercises.singleWhere(
        (workoutExercise) => workoutExercise.id == editWorkoutExerciseId);

    workoutExercises = editWorkout.workoutExercises
        .where((workoutExercise) => workoutExercise.id != editWorkoutExerciseId)
        .toList();

    exerciseSets = editWorkoutExercise.exerciseSets
        .map((exercise) =>
            new ExerciseSet(weight: exercise.weight, number: exercise.number))
        .toList();

    final indexOfEditWorkout = state.workoutRef.indexOf(editWorkout);
    final indexOfEditExercise =
        editWorkout.workoutExercises.indexOf(editWorkoutExercise);

    switch (action) {
      case Constants.ADD_ACTION:
        {
          exerciseSets.add(new ExerciseSet(
              weight: params.newWeight, number: params.newRepCount));
        }
        break;
      case Constants.DELETE_ACTION:
        {
          exerciseSets.removeAt(params.index);
        }
        break;
      case Constants.EDIT_ACTION:
        {
          exerciseSets[params.index] = new ExerciseSet(
              weight: params.newWeight, number: params.newRepCount);
        }
        break;
    }
    workoutExercises.insert(
        indexOfEditExercise,
        new WorkoutExercise(
            id: editWorkoutExercise.id,
            exerciseId: editWorkoutExercise.exerciseId,
            name: editWorkoutExercise.name,
            exerciseSets: exerciseSets,
            supersets: editWorkoutExercise.supersets));

    editWorkout = new Workout(
        id: editWorkout.id,
        name: editWorkout.name,
        workoutExercises: workoutExercises,
        description: editWorkout.description);
    workouts.insert(indexOfEditWorkout, editWorkout);

    editProgram = new Program(name: programRef.name, workouts: workouts);
    return WorkoutActionState(programRef: editProgram, workoutRef: workouts);
  }
}
