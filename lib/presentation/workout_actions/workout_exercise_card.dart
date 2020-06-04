import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stronk/domain/constants.dart' as Constants;
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/presentation/workout_actions/PopUpMenu.dart';
import 'package:stronk/presentation/workout_actions/workout_action_bloc.dart';
import 'package:stronk/presentation/workout_actions/workout_action_exerciseSetDisplay.dart';

enum workoutOptions {
  editWorkoutName,
  editWorkoutDescription,
  deleteWorkoutExercise,
  addWorkoutExercise
}

class WorkoutExerciseCard extends StatelessWidget {
  final WorkoutExercise workoutExercise;
  final String workoutId;
  final WorkoutActionBloc bloc;

  WorkoutExerciseCard(
      {@required this.workoutExercise,
      @required this.workoutId,
      @required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 120,
        margin: EdgeInsets.symmetric(horizontal: 2),
        child: InkWell(
          onTap: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WorkoutExercisesSetPage(
                        workoutId: workoutId,
                        workoutExerciseId: workoutExercise.id,
                        exerciseSet: workoutExercise.exerciseSets,
                        bloc: bloc)))
          },
          child: Card(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ListTile(trailing: buildPopUpMenu(context)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text("$workoutId\n"
                          "${workoutExercise.id},\n"
                          "${workoutExercise.exerciseSets}"),
                    ),
                  )
                ]),
          ),
        ));
  }

  Widget buildPopUpMenu(BuildContext context) {
    return PopUpMenu.createPopup([
      new PopUpMenu(
          option: "Edit Workout Description",
          onTap: () => {
                bloc.add(new EditWorkoutEvent(
                    workoutId: workoutId,
                    editAction: Constants.EDIT_WORKOUT_DESCRIPTION,
                    newValue: "new description"))
              }),
      new PopUpMenu(
          option: "Edit Workout Name",
          onTap: () => {
                bloc.add(new EditWorkoutEvent(
                    workoutId: workoutId,
                    editAction: Constants.EDIT_WORKOUT_NAME,
                    newValue: "new workout Name"))
              }),
      new PopUpMenu(
          option: "Delete WorkoutExercise",
          onTap: () => {
                bloc.add(new WorkoutExercisesEvent(
                    workoutId: workoutId,
                    workoutExerciseId: workoutExercise.id,
                    action: Constants.DELETE_ACTION))
              }),
      new PopUpMenu(
          option: "Add workout exercise",
          onTap: () => {
                bloc.add(new WorkoutExercisesEvent(
                    workoutId: workoutId,
                    workoutExerciseId: "1000",
                    action: Constants.ADD_ACTION))
              })
    ]);
  }
}
