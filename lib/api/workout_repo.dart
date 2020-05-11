import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:stronk/domain/model/workout.dart';

import 'graphql.dart';

abstract class WorkoutRepository {
  Future<Program> retrieveProgram();
  Future<Workout> retrieveWorkout();
}

class WorkoutRepositoryImpl implements WorkoutRepository {
  GraphQLUtility utility;

  static final random = Random(1);

  WorkoutRepositoryImpl({@required GraphQLUtility utility});

  @override
  Future<Program> retrieveProgram() async {
    return _mockProgram();
  }

  @override
  Future<Workout> retrieveWorkout() async {
    return mockWorkout();
  }

  static WorkoutExercise _mockWorkoutExercise() {
    final mockExerciseSets = [
      _mockExerciseSetparams(),
      _mockExerciseSetparams(),
      _mockExerciseSetparams(),
    ];

    final mockWorkoutExercise = new WorkoutExercise(
      id: "${random.nextInt(10000)}",
      name: "workout name",
      exerciseId: "1",
      exerciseSets: mockExerciseSets,
      supersets: [],
    );

    return (mockWorkoutExercise);
  }

  static ExerciseSet _mockExerciseSetparams() {
    return new ExerciseSet(weight: 20, number: 6);
  }

  static Workout mockWorkout() {
    final mockWorkoutExercises = [
      _mockWorkoutExercise(),
      _mockWorkoutExercise(),
      _mockWorkoutExercise(),
    ];

    final mockWorkout = Workout(
        id: "${random.nextInt(10000)}",
        name: "mock workout",
        description: "mock description",
        workoutExercises: mockWorkoutExercises);

    return mockWorkout;
  }

  static Program _mockProgram() {
    final mockWorkouts = [
      mockWorkout(),
      mockWorkout(),
      mockWorkout(),
    ];

    return new Program(name: "mock program name", workouts: mockWorkouts);
  }
}
