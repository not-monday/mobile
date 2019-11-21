import 'package:stronk/domain/model/program.dart';
import 'package:stronk/domain/model/workout.dart';

class ProgramRepository {
  Future<Program> retrieveProgram() async {
    // todo replace with real program fetch call
    return Program(name: "Test program");
  }

  Future<Workout> retrieveWorkout() async {
    // todo replace with real program fetch call
    final testWorkout = Workout(id: "test");
    final testWorkoutExercise = WorkoutExercise(id: "test", exerciseId: "test", workout: testWorkout);

    final workoutExercises = [
      testWorkoutExercise,
      testWorkoutExercise,
      testWorkoutExercise,
      testWorkoutExercise,
      testWorkoutExercise,
      testWorkoutExercise,
      testWorkoutExercise,
      testWorkoutExercise,
      testWorkoutExercise,
      testWorkoutExercise,
      testWorkoutExercise,
      testWorkoutExercise,
      testWorkoutExercise,
      testWorkoutExercise,
      testWorkoutExercise,
      testWorkoutExercise,
      testWorkoutExercise,
      testWorkoutExercise
    ];
    return Workout(
        name: "Test program",
        id: "test",
        workoutExercises: workoutExercises
    );
  }
}