import 'package:flutter/cupertino.dart';
import 'package:stronk/domain/model/exercise.dart';

class Workout {
  String id;
  String name;
  String description;
  List<Exercise> exercises;

  Workout({
    @required this.id,
    this.name = "test",
    this.exercises = const [],
    this.description = "test description"
  });

}

class WorkoutExercise {
  final String id;  // id uniquely identifies the exercise with context to this workout
  final String exerciseId;  // refers to the global exercise id
  final List<WorkoutExercise> supersets; // exercises being superset with this one

  List<ExerciseSet> exerciseSets; // each set of the exercise

  WorkoutExercise({
    @required this.id,
    @required this.exerciseId,
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