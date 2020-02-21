
// represents an entire workout
import 'package:flutter/foundation.dart';

class Workout {
  final String id;
  final String name;
  final String description;
  final List<WorkoutExercise> workoutExercises;

  Workout({
    @required this.id,
    this.name = "test",
    this.workoutExercises = const [],
    this.description = "test description",
  });
}

// represents an exercise in a workout
class WorkoutExercise {
  final String id;  // id uniquely identifies the exercise with context to// this workout
  final String name;// refers to the global exercise id
  final String exerciseId;
  final List<ExerciseSet> exerciseSets; // each set of the exercise
  final List<WorkoutExercise> supersets; // exercises being superset with this one

  WorkoutExercise({
    @required this.id,
    @required this.exerciseId,
    @required this.name,
    this.exerciseSets = const [],
    this.supersets = const[],
  });
}


// represents each "set" for a specific exercise with a weight and rep value
class ExerciseSet {
  final int weight;
  final int number;

  ExerciseSet({
    @required this.weight,
    @required this.number
  });
}

class Exercise {
  final String id;
  final String description;

  Exercise({
    @required this.id,
    @required this.description,
  });
}

// represents an exercise program
class Program {
  final String name;
  final List<Workout> workouts;

  Program({
    @required this.name,
    this.workouts = const [],
  });
}