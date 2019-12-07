import 'package:flutter/cupertino.dart';

class Workout {
  String id;
  String name;
  String description;
  List<WorkoutExercise> workoutExercises;
  bool completed;

  Workout({
    @required this.id,
    this.name = "test",
    this.workoutExercises = const [],
    this.description = "test description",
    this.completed = false
  });
}

class WorkoutExercise {
  final String id;  // id uniquely identifies the exercise with context to// this workout
  final String exerciseId;
  final String name;// refers to the global exercise id
  final List<ExerciseSet> exerciseSets; // each set of the exercise
  final List<WorkoutExercise> supersets; // exercises being superset with this one
  bool completed;

  WorkoutExercise({
    @required this.id,
    @required this.exerciseId,
    @required this.name,
    this.exerciseSets = const [],
    this.supersets = const[],
    this.completed = false
  });
}

class ExerciseSet {
  final int weight;
  final int reps;
  bool completed;
  bool failed;

  ExerciseSet({
    @required this.weight,
    @required this.reps,
    this.completed = false,
    this.failed = false
  });
}