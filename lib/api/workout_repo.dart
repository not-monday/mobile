import 'package:stronk/domain/model/workout.dart';
import 'dart:math';

abstract class WorkoutRepository {
    Program retrieveProgram();
    Workout retrieveWorkout();
}

class WorkoutRepositoryImpl implements WorkoutRepository {
  final random = Random(1);

  @override
  Program retrieveProgram() {
    return _mockProgram();
  }

  @override
  Workout retrieveWorkout() {
    return _mockWorkout();
  }

  WorkoutExercise _mockWorkoutExercise() {
    final mockExerciseSets = [
        _mockExerciseSetparams(),
        _mockExerciseSetparams(),
        _mockExerciseSetparams(),
    ];

    final mockWorkoutExercise = new WorkoutExercise(
        id : "${random.nextInt(10000)}",
        name: "workout name",
        exerciseId: "1",
        exerciseSets: mockExerciseSets,
        supersets: [],
    );

    return (mockWorkoutExercise);
  }

  ExerciseSet _mockExerciseSetparams() {
      return new ExerciseSet(
        weight : 20,
        number: 6
      );
  }

  Workout _mockWorkout() {
      final mockWorkoutExercises = [
          _mockWorkoutExercise(),
          _mockWorkoutExercise(),
          _mockWorkoutExercise(),
      ];

      final mockWorkout = Workout(
        id : "${random.nextInt(10000)}",
        name: "mock workout",
        description: "mock description",
        workoutExercises: mockWorkoutExercises
      );

      return mockWorkout; 
  }

  Program _mockProgram() {
      final mockWorkouts = [
          _mockWorkout(),
          _mockWorkout(),
          _mockWorkout(),
      ];

      return new Program(
          name: "mock program name",
          workouts: mockWorkouts
      );
  }
}