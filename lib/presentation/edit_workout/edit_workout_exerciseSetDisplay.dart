import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/presentation/edit_workout/param_container.dart';

import 'edit_workout_bloc.dart';

class WorkoutExercisesSetPage extends StatelessWidget {
  final String workoutId;
  final String workoutExerciseId;
  final List<ExerciseSet> exerciseSet;
  final EditWorkoutBloc bloc;

  WorkoutExercisesSetPage(
      {this.workoutId, this.workoutExerciseId, this.exerciseSet, this.bloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _renderExerciseSet(exerciseSet));
  }

  Widget _renderExerciseSet(List<ExerciseSet> set) {
    return Container(
      child: ListView.builder(
          itemCount: set.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(children: <Widget>[
              ListTile(
                title: Text("$workoutId\n"
                    "$workoutExerciseId,\n"
                    "${exerciseSet[index]}"),
                onTap: () => {
                  bloc.add(new EditWorkoutExerciseSetsRepsEvent(
                      new ParamContainer(
                          newWeight: 20,
                          newRepCount: 10,
                          workoutId: workoutId,
                          workoutExerciseId: workoutExerciseId),
                      index))
                },
              ),
              Divider(),
            ]);
          }),
    );
  }
}
