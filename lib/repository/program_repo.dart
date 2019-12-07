import 'package:stronk/domain/model/program.dart';
import 'package:stronk/domain/model/workout.dart';

class ProgramRepository {
  Future<Program> retrieveProgram() async {
    // todo replace with real program fetch call
    return Program(name: "Test program");
  }

  Future<Workout> retrieveWorkout() async {
    final exerciseSetFactory = () => [
      ExerciseSet(weight: 50, reps: 8),
      ExerciseSet(weight: 60, reps: 6),
      ExerciseSet(weight: 70, reps: 4)
    ];

    final workoutExerciseFactory = () => WorkoutExercise(
      id: "test",
      exerciseId: "test",
      exerciseSets: exerciseSetFactory(),
      name: "dumbell press"
    );

    final workoutExercises = [
      workoutExerciseFactory(),
      workoutExerciseFactory(),
      workoutExerciseFactory(),
      workoutExerciseFactory(),
      workoutExerciseFactory(),
    ];

    return Workout(
        name: "Test program",
        id: "test",
        workoutExercises: workoutExercises
    );
  }


}