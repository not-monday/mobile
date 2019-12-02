import 'package:stronk/domain/model/program.dart';
import 'package:stronk/domain/model/workout.dart';

class ProgramRepository {
  Future<Program> retrieveProgram() async {
    // todo replace with real program fetch call
    return Program(name: "Test program");
  }

  Future<Workout> retrieveWorkout() async {
    final mockExerciseSets = [
      ExerciseSet(weight: 50, reps: 8),
      ExerciseSet(weight: 60, reps: 6),
      ExerciseSet(weight: 70, reps: 4)
    ];

    // todo replace with real program fetch call
    final testWorkoutExercise = WorkoutExercise(
        id: "test",
        exerciseId: "test",
        exerciseSets: mockExerciseSets
    );

    final workoutExercises = [
      testWorkoutExercise,
      testWorkoutExercise,
      testWorkoutExercise,
      testWorkoutExercise,
      testWorkoutExercise,
    ];

    return Workout(
        name: "Test program",
        id: "test",
        workoutExercises: workoutExercises
    );
  }
}