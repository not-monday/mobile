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

  @override
  String toString() {
    return ("\nid: $id\n"
        "id: $name\n"
        "description: $description\n"
        "workoutExercises: $workoutExercises\n");
  }
}

// represents an exercise in a workout
class WorkoutExercise {
  final String id; // id uniquely identifies the exercise wrt this workout
  final String name; // refers to the global exercise id
  final String exerciseId;
  final List<ExerciseSet> exerciseSets; // each set of the exercise
  final List<WorkoutExercise>
      supersets; // exercises being superset with this one

  WorkoutExercise({
    @required this.id,
    @required this.exerciseId,
    @required this.name,
    this.exerciseSets = const [],
    this.supersets = const [],
  });

  @override
  String toString() {
    return ("\nid: $id\n"
        "name: $name\n"
        "exerciseId: $exerciseId\n"
        "exerciseSets: $exerciseSets\n"
        "supersets: $supersets\n");
  }
}

// represents each "set" for a specific exercise with a weight and rep value
class ExerciseSet {
  final int weight;
  final int number;

  ExerciseSet({@required this.weight, @required this.number});

  @override
  String toString() {
    return ("\nweight: $weight\n"
        "number: $number\n");
  }
}

class Exercise {
  final String id;
  final String description;

  Exercise({
    @required this.id,
    @required this.description,
  });

  @override
  String toString() {
    return ("\nid: $id\n"
        "description: $description\n");
  }
}

// represents an exercise program
class Program {
  final String name;
  final List<Workout> workouts;

  Program({
    @required this.name,
    this.workouts = const [],
  });

  @override
  String toString() {
    return ("\nname: $name\n"
        "workouts: $workouts\n ");
  }
}
