import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stronk/domain/constants.dart' as Constants;
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/presentation/workout_actions/param_container.dart';

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
          itemCount: set.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(children: <Widget>[
              ListTile(
                title: Text("$workoutId\n"
                    "$workoutExerciseId,\n"
                    "${exerciseSet[index]}"),
                trailing: PopupMenuButton<workoutExerciseOptions>(
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<workoutExerciseOptions>>[
                    PopupMenuItem<workoutExerciseOptions>(
                      child: FlatButton(
                          child: Text("Edit set and reps"),
                          onPressed: () => {
                                bloc.add(new SetsAndRepsEvent(
                                  params: new ParamContainer(
                                      newWeight: 20,
                                      newRepCount: 10,
                                      workoutId: workoutId,
                                      workoutExerciseId: workoutExerciseId,
                                      index: index,
                                      action: Constants.EDIT_ACTION),
                                ))
                              }),
                    ),
                    PopupMenuItem<workoutExerciseOptions>(
                        child: FlatButton(
                            child: Text("Delete Set"),
                            onPressed: () => {
                                  bloc.add(new SetsAndRepsEvent(
                                      params: new ParamContainer(
                                          workoutId: workoutId,
                                          workoutExerciseId: workoutExerciseId,
                                          index: index,
                                          action: Constants.DELETE_ACTION)))
                                })),
                    PopupMenuItem<workoutExerciseOptions>(
                        child: FlatButton(
                            child: Text("Add set"),
                            onPressed: () => {
                                  bloc.add(new SetsAndRepsEvent(
                                      params: new ParamContainer(
                                          workoutId: workoutId,
                                          workoutExerciseId: workoutExerciseId,
                                          newWeight: 10,
                                          newRepCount: 10,
                                          action: Constants.ADD_ACTION)))
                                }))
                  ],
                ),
              ),
              Divider(),
            ]);
          }),
    );
  }
}
