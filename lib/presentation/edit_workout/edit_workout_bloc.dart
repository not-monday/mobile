import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/domain/model/workout.dart';
import 'ParamContainer.dart';

class EditWorkoutState {
  final Program programRef;
  final List<Workout> workoutRef;

  EditWorkoutState({@required this.programRef, this.workoutRef});

  @override
  String toString() {
    return ("\n workoutRef: $programRef\n");
  }
}

@sealed
abstract class _Event {}

class InitEvent implements _Event {}

class EditWorkoutNameEvent implements _Event {
  String workoutNewName;
  String workoutId;

  EditWorkoutNameEvent(this.workoutId, this.workoutNewName);
}

class EditWorkoutSetsRepsEvent implements _Event {
  ParamContainer paramContainer;
  int index;

  EditWorkoutSetsRepsEvent(this.paramContainer, this.index);
}

class EditWorkoutDescriptionEvent implements _Event {
  String workoutId;
  String newWorkoutDescription;

  EditWorkoutDescriptionEvent(this.workoutId, this.newWorkoutDescription);
}

class EditProgramNameEvent implements _Event {
  // Once the schema supports more than one program
  //String programId;
  String newName;

  EditProgramNameEvent(this.newName);
}

class EditWorkoutBloc extends Bloc<_Event, EditWorkoutState> {
  final WorkoutRepository workoutRepo;

  @override
  EditWorkoutState get initialState => new EditWorkoutState(programRef: null);

  @override
  Stream<EditWorkoutState> mapEventToState(_Event event) async* {
    var newState = state;
    if (event is InitEvent) {
      newState = await handleInit().catchError((error) => print(error));
    } else if (event is EditWorkoutSetsRepsEvent) {
      newState = await handleEditWorkout(event.paramContainer, event.index)
          .catchError((error) => print(error));
    } else if (event is EditProgramNameEvent) {
      newState = await handleEditProgramName(event.newName)
          .catchError((error) => print(error));
    } else if (event is EditWorkoutDescriptionEvent) {
      newState = await handleEditWorkoutDescription(
              event.workoutId, event.newWorkoutDescription)
          .catchError((error) => print(error));
    } else if (event is EditWorkoutNameEvent) {
      newState =
          await handleEditWorkoutName(event.workoutId, event.workoutNewName)
              .catchError((error) => print(error));
    }

    yield newState;
  }

  EditWorkoutBloc({@required this.workoutRepo}) {
    add(new InitEvent());
  }

  Future<EditWorkoutState> handleInit() async {
    final activeWorkout = await workoutRepo.retrieveProgram();

    return EditWorkoutState(
        programRef: activeWorkout, workoutRef: activeWorkout.workouts);
  }

  Future<EditWorkoutState> handleEditWorkout(
      ParamContainer paramContainer, int index) async {
    return _editWorkout(paramContainer, index);
  }

  Future<EditWorkoutState> handleEditProgramName(String newName) async {
    return _editProgramName(newName);
  }

  Future<EditWorkoutState> handleEditWorkoutName(
      String workoutId, String newName) async {
    return _editWorkoutName(workoutId, newName);
  }

  Future<EditWorkoutState> handleEditWorkoutDescription(
      String workoutId, String description) async {
    return _editWorkoutDescription(workoutId, description);
  }

  EditWorkoutState _editWorkout(ParamContainer paramContainer, int index) {
    final programRef = state.programRef;
    final workoutRef = state.workoutRef;
    final editWorkoutId = paramContainer.workoutId;
    final editWorkoutExerciseId = paramContainer.workoutExerciseId;
    final newWeight = paramContainer.newWeight;
    final newRepCount = paramContainer.newRepCount;

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
    exerciseSets[index] =
        new ExerciseSet(weight: newWeight, number: newRepCount);

    workoutExercises.add(new WorkoutExercise(
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

    workouts.add(editWorkout);
    editProgram = new Program(name: programRef.name, workouts: workouts);

    return new EditWorkoutState(programRef: editProgram, workoutRef: workouts);
  }

  _editProgramName(String newName) {
    if (state.programRef == null) {
      return null;
    }

    final editedProgram =
        new Program(name: newName, workouts: state.programRef.workouts);
    return new EditWorkoutState(
        programRef: editedProgram, workoutRef: editedProgram.workouts);
  }

  _editWorkoutDescription(String workoutId, String newWorkoutDescription) {
    if (state.programRef == null) {
      return null;
    } else if (state.workoutRef == []) {
      return state;
    }
    List<Workout> workouts;

    Workout targetWorkout =
        state.workoutRef.singleWhere((workout) => workout.id == workoutId);
    workouts =
        state.workoutRef.where((workout) => workout.id != workoutId).toList();
    final indexOfTargetWorkout = state.workoutRef.indexOf(targetWorkout);
    var editedWorkout = new Workout(
        name: targetWorkout.name,
        id: targetWorkout.id,
        description: newWorkoutDescription,
        workoutExercises: targetWorkout.workoutExercises);
    workouts.insert(indexOfTargetWorkout, editedWorkout);

    final updatedProgram =
        new Program(name: state.programRef.name, workouts: workouts);

    return EditWorkoutState(
        programRef: updatedProgram, workoutRef: updatedProgram.workouts);
  }

  _editWorkoutName(String workoutId, String workoutNewName) {
    if (state.programRef == null) {
      return null;
    } else if (state.workoutRef == []) {
      return state;
    }
    List<Workout> workouts;

    Workout targetWorkout =
        state.workoutRef.singleWhere((workout) => workout.id == workoutId);
    workouts =
        state.workoutRef.where((workout) => workout.id != workoutId).toList();
    final indexOfTargetWorkout = state.workoutRef.indexOf(targetWorkout);
    var editedWorkout = new Workout(
        id: workoutId,
        name: workoutNewName,
        description: targetWorkout.description,
        workoutExercises: targetWorkout.workoutExercises);
    workouts.insert(indexOfTargetWorkout, editedWorkout);

    final updatedProgram =
        new Program(name: state.programRef.name, workouts: workouts);

    return EditWorkoutState(
        programRef: updatedProgram, workoutRef: updatedProgram.workouts);
  }
}
