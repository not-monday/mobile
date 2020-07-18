class ProgramDocument {
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