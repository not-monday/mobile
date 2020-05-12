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

class EditWorkoutSetsRepsEvent implements _Event {
  ParamContainer paramContainer;
  int index;

  EditWorkoutSetsRepsEvent(this.paramContainer, this.index);
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
    } else if(event is EditProgramNameEvent) {
      newState = await handleEditProgramName(event.newName);
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

  handleEditProgramName(String newName) {
    if(state.programRef == null) {
      return null;
    }

    final editedProgram = new Program(name: newName, workouts: state.programRef.workouts);
    return new EditWorkoutState(
      programRef : editedProgram,
      workoutRef : editedProgram.workouts
    );
  }
}
