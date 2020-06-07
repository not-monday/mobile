import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/presentation/workout_actions/workout_exercise_set_card.dart';

import 'workout_action_bloc.dart';

enum workoutExerciseOptions {
  editWorkoutExerciseSetsAndReps,
  deleteWorkoutExerciseSet
}

class WorkoutExercisesSetPage extends StatelessWidget {
  final String workoutId;
  final String workoutExerciseId;
  final List<ExerciseSet> exerciseSet;
  final WorkoutActionBloc bloc;

  WorkoutExercisesSetPage(
      {this.workoutId, this.workoutExerciseId, this.exerciseSet, this.bloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _renderExerciseSet(exerciseSet));
  }

  Widget _renderExerciseSet(List<ExerciseSet> set) {
    return Container(
      child: ListView.builder(
        //For now set item count as 1 since there will only be one program
        itemCount: exerciseSet.length,
        itemBuilder: (context, index) {
          return WorkoutExercisesSetCard(
              workoutId: workoutId,
              workoutExerciseId: workoutExerciseId,
              index: index,
              exerciseSet: exerciseSet[index],
              bloc: bloc);
        },
      ),
    );
  }
}
