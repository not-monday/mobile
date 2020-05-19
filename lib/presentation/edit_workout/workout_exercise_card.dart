import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stronk/domain/constants.dart' as Constants;
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/presentation/edit_workout/edit_workout_bloc.dart';
import 'package:stronk/presentation/edit_workout/edit_workout_exerciseSetDisplay.dart';

enum Options { editWorkoutName, editWorkoutDescription }

class WorkoutExerciseCard extends StatelessWidget {
  final WorkoutExercise workoutExercise;
  final String workoutId;
  final EditWorkoutBloc bloc;

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
                  ListTile(
                    trailing: PopupMenuButton<Options>(
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<Options>>[
                              PopupMenuItem<Options>(
                                  value: Options.editWorkoutDescription,
                                  child: FlatButton(
                                    child: Text("Edit Workout Description"),
                                    onPressed: () => {
                                      bloc.add(new EditWorkoutEvent(
                                          workoutId: workoutId, editAction : Constants.EDIT_WORKOUT_DESCRIPTION, newValue: "new description"))
                                    },
                                  )),
                              PopupMenuItem<Options>(
                                  value: Options.editWorkoutName,
                                  child: FlatButton(
                                      child: Text("Edit Workout Name"),
                                      onPressed: () => {
                                            bloc.add(new EditWorkoutEvent(
                                               workoutId: workoutId, editAction: Constants.EDIT_WORKOUT_NAME, newValue : "new workout Name"))
                                          }))
                            ]),
                  ),
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
}
