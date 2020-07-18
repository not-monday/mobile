class WorkoutDocument {
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