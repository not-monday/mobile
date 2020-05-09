import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/presentation/component/workout_exercise_card.dart';

import 'edit_workout_bloc.dart';

class WorkoutExercisesPage extends StatelessWidget {
  final List<WorkoutExercise> set;
  final String workoutId;
  final EditWorkoutBloc bloc;

  WorkoutExercisesPage({this.set, this.workoutId, this.bloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _renderExercise(this.set));
  }

  Widget _renderExercise(List<WorkoutExercise> set) {
    return Container(
        child: ListView.builder(
            itemCount: set.length,
            itemBuilder: (BuildContext context, int index) {
              return (WorkoutExerciseCard(
                  workoutExercise: set[index],
                  workoutId: this.workoutId,
                  bloc: bloc));
            }));
  }
}
