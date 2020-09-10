import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:stronk/api/graphql/workoutDocument.dart';
import 'package:stronk/domain/model/workout.dart';

import 'graphql.dart';

abstract class WorkoutRepository {
  Future<Program> retrieveProgram();

  Future<Workout> mockRetrieveWorkout();

  Future<Program> createProgram(String programName, int duration, String description);
}

class WorkoutRepositoryImpl implements WorkoutRepository {
  GraphQLUtility utility;


  WorkoutRepositoryImpl({@required this.utility});

  @override
  Future<Program> retrieveProgram() async {
    return mockProgram();
  }

  @override
  Future<Workout> mockRetrieveWorkout() async {
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

    return new Program(author : "mock author", name: "mock program name", workouts: mockWorkouts, description: "test", duration: 10, id: "1", parentId: "2");
  }

  @override
  Future<Program> createProgram(String programName, int duration, String description) async {
    final MutationOptions mutationOptions = MutationOptions(documentNode: gql(WorkoutDocument.createProgram(programName, duration, description)));
    final QueryResult queryResult = await utility.client.mutate(mutationOptions);
    if (queryResult.hasException) {
      log("Error updating user email ${queryResult.exception}");
    }
    final programData = queryResult.data['createProgram']['program'];
    return new Program(id: programData['id'], parentId: programData['parentId'], name: programData['name'], author: programData['author']['name'], duration: programData['duration'], description: programData['description']);
  }

}
