import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stronk/presentation/workout_actions/PopUpMenu.dart';
import 'package:stronk/domain/constants.dart' as Constants;
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/presentation/workout_actions/param_container.dart';

import 'workout_action_bloc.dart';

class WorkoutExercisesSetCard extends StatelessWidget {
  final String workoutId;
  final String workoutExerciseId;
  final ExerciseSet exerciseSet;
  final int index;
  final WorkoutActionBloc bloc;

  WorkoutExercisesSetCard(
      {this.workoutId,
      this.workoutExerciseId,
      this.exerciseSet,
      this.bloc,
      this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
          ListTile(trailing: buildPopUpMenu(context)),
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  child: Text("$workoutId \n"
                      "$workoutExerciseId\n"
                      "$exerciseSet\n"))),
        ])));
  }

  Widget buildPopUpMenu(BuildContext context) {
    return PopUpMenu.createPopup([
      new PopUpMenu(
          option: "Add set",
          onTap: () => {
                bloc.add(new SetsAndRepsEvent(
                    params: new ParamContainer(
                        workoutId: workoutId,
                        workoutExerciseId: workoutExerciseId,
                        newWeight: 10,
                        newRepCount: 10,
                        action: Constants.ADD_ACTION)))
              }),
      new PopUpMenu(
          option: "Edit set and reps",
          onTap: () => {
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
      new PopUpMenu(
          option: "Delete set",
          onTap: () => {
                bloc.add(new SetsAndRepsEvent(
                    params: new ParamContainer(
                        workoutId: workoutId,
                        workoutExerciseId: workoutExerciseId,
                        index: index,
                        action: Constants.DELETE_ACTION)))
              })
    ]);
  }
}
