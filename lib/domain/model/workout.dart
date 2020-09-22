// represents an entire workout
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'workout.g.dart';

@JsonSerializable()
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
        "name: $name\n"
        "description: $description\n"
        "workoutExercises: $workoutExercises\n");
  }

  factory Workout.fromJson(Map<String, dynamic> json) => _$WorkoutFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutToJson(this);
}

// represents an exercise in a workout
@JsonSerializable()
class WorkoutExercise {
  final String id; // id uniquely identifies the exercise wrt this workout
  final String name; // refers to the global exercise id
  final String exerciseId;
  final List<ExerciseSet> exerciseSets; // each set of the exercise
  final List<WorkoutExercise> supersets; // exercises being superset with this one

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

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) => _$WorkoutExerciseFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutExerciseToJson(this);
}

// represents each "set" for a specific exercise with a weight and rep value
@JsonSerializable()
class ExerciseSet {
  final int weight;
  final int number;

  ExerciseSet({@required this.weight, @required this.number});

  @override
  String toString() {
    return ("\nweight: $weight\n"
        "number: $number\n");
  }

  factory ExerciseSet.fromJson(Map<String, dynamic> json) => _$ExerciseSetFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseSetToJson(this);
}

@JsonSerializable()
class Exercise {
  final String id;
  final String description;

  Exercise({
    @required this.id,
    @required this.description,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseToJson(this);
}

// represents an exercise program
@JsonSerializable()
class Program {
  final String id;
  final String parentId;
  final String author;
  final String name;
  final int duration;
  final String description;

  final List<Workout> workouts;

  Program({
    @required this.id,
    @required this.parentId,
    @required this.author,
    @required this.name,
    @required this.duration,
    @required this.description,
    this.workouts = const [],
  });

  factory Program.fromJson(Map<String, dynamic> json) => _$ProgramFromJson(json);

  Map<String, dynamic> toJson() => _$ProgramToJson(this);
}
