class ProgramDocument {
  static String queryProgram(String userId) => """
    query {
      program(id: $userId) {
        id, name, duration, description, 
        workouts {
          id, name, description, projectedTime
        }
      }
    }
  """;

  static String queryPrograms() => """
    query {
      programs {
        id, name, duration, description, 
        workouts {
          id, name, description, projectedTime
        }
      }
    }
  """;

}