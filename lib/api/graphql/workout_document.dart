class WorkoutDocument {
  static String queryProgram(int programId) => """
    query {
      program(id: $programId) {
        id, name, duration, description, 
        workouts {
          id, name, description, projectedTime
        }
      }
    }
  """;

  static String queryWorkouts(int id) => """
    
  """;

  static String queryWorkout(int id) => """
    workout(id: $id) {
      id, name, description, projectedTime, 
      workoutExercises {
        workoutId, exerciseId, workoutReps, workoutWeights, restTime,
        exercise {
          id, name, description
        }
      }
    }
  """;
}