import 'package:flutter/foundation.dart';
import 'package:stronk/domain/model/workout.dart';

enum Status { Incomplete, Passed, Failed }

class ExerciseRecord extends WorkoutExercise {
  Status status;

  ExerciseRecord({@required this.status, @required WorkoutExercise exercise})
      : super(
            exerciseId: exercise.exerciseId,
            id: exercise.id,
            name: exercise.name,
            exerciseSets: exercise.exerciseSets,
            supersets: exercise.supersets);

  @override
  String toString() {
    return ("\nid: $id\n"
        "name: $name\n"
        "exerciseId: $exerciseId\n"
        "exerciseSets: $exerciseSets\n"
        "supersets: $supersets\n"
        "status: $status \n");
  }
}

class SetRecord extends ExerciseSet {
  Status status;
  int repsBeforeFailure;

  SetRecord(
      {@required this.status,
      @required this.repsBeforeFailure,
      @required ExerciseSet exerciseSet})
      : super(weight: exerciseSet.weight, number: exerciseSet.number);

  @override
  String toString() {
    return ("\nweight: $weight\n"
        "number: $number\n"
        "status: $status\n"
        "repsBeforeFailure: $repsBeforeFailure");
  }
}
