import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:stronk/domain/model/workout.dart';

import 'graphql.dart';
import 'graphql/workout_document.dart';

abstract class WorkoutRepository {
  Future<Program> retrieveProgram();
  Future<Workout> retrieveWorkout();
}

class WorkoutRepositoryImpl implements WorkoutRepository {
  GraphQLUtility utility;

//  static final random = Random(1);

  WorkoutRepositoryImpl({@required this.utility});

  @override
  Future<Program> retrieveProgram() async {
    // TODO use current user program, currently blocked by user profile PR
    final id = "1";
    final node = gql(WorkoutDocument.queryProgram(id));
    final options = QueryOptions(documentNode: node);

    final result = await utility.client.query(options);
    if (result.hasException) {
      log("error retrieving program for user id $id");


      // TODO
      return null;
    }

    return mockProgram();
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
      id: "1",
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
        id: "1",
        name: "mock workout",
        description: "mock description",
        workoutExercises: mockWorkoutExercises);

    return mockWorkout;
  }

  static Program mockProgram() {
    final mockWorkouts = [
      mockWorkout(),
      mockWorkout(),
      mockWorkout(),
    ];

    return new Program(name: "mock program name", workouts: mockWorkouts);
  }
}
