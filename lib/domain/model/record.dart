import 'package:flutter/foundation.dart';
import 'package:stronk/domain/model/workout.dart';

enum Status{
  Incomplete,
  Passed,
  Failed
}

class ExerciseRecord extends WorkoutExercise {
  Status status;

  ExerciseRecord({
    @required this.status,
    @required WorkoutExercise exercise
  }): super(
    exerciseId: exercise.exerciseId, 
    id: exercise.id, 
    name: exercise.name,
    exerciseSets: exercise.exerciseSets,
    supersets: exercise.supersets
  );
}

class SetRecord extends ExerciseSet {
  Status status;
  int repsBeforeFailure;

  SetRecord({
    @required this.status,
    @required this.repsBeforeFailure,
    @required ExerciseSet exerciseSet
  }): super(
    weight: exerciseSet.weight,
    number: exerciseSet.number
  );
}