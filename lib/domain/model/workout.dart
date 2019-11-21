import 'package:flutter/cupertino.dart';

class Workout {
  String id;
  String name;
  String description;
  List<WorkoutExercise> workoutExercises;

  Workout({
    @required this.id,
    this.name = "test",
    this.workoutExercises = const [],
    this.description = "test description"
  });
}

class WorkoutExercise {
  final String id;  // id uniquely identifies the exercise with context to this workout
  final String exerciseId;  // refers to the global exercise id
  final Workout workout;
  final List<WorkoutExercise> supersets; // exercises being superset with this one

  List<ExerciseSet> exerciseSets; // each set of the exercise

  WorkoutExercise({
    @required this.id,
    @required this.exerciseId,
    @required this.workout,
    this.exerciseSets = const [],
    this.supersets = const[],
  });
}

class ExerciseSet {
  final int weight;
  final int reps;

  ExerciseSet({
    @required this.weight,
    @required this.reps,
  });
}