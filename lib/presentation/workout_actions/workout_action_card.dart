import 'package:flutter/material.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/domain/constants.dart' as Constants;
import 'package:stronk/presentation/workout_actions/PopUpMenu.dart';
import 'package:stronk/presentation/workout_actions/workout_action_bloc.dart';
import 'package:stronk/presentation/workout_actions/workout_action_exercise_display.dart';

enum programOptions { editProgramName, addWorkout, deleteWorkout }

class WorkoutActionCard extends StatelessWidget {
  final Workout workout;
  final String programName;
  final WorkoutActionBloc bloc;

  WorkoutActionCard({@required this.workout, this.programName, this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      child: InkWell(
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WorkoutExercisesPage(
                      set: workout.workoutExercises,
                      workoutId: workout.id,
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
                      child: Text("$programName \n"
                          "${workout.name}\n"
                          "${workout.id}\n"
                          "${workout.description}\n"
                          "${workout.workoutExercises}\n"))),
            ])),
      ),
    );
  }

  Widget buildPopUpMenu(BuildContext context) {
    return PopUpMenu.createPopup([
      new PopUpMenu(
          option: "Add workout",
          onTap: () => {
                bloc.add(new WorkoutEvent(
                    workoutId: "1000", action: Constants.ADD_ACTION))
              }),
      new PopUpMenu(
          option: "Delete Workout",
          onTap: () => {
                bloc.add(new WorkoutEvent(
                    workoutId: workout.id, action: Constants.DELETE_ACTION))
              }),
      new PopUpMenu(
          option: "Edit program name",
          onTap: () =>
              {bloc.add(new EditProgramNameEvent("Editted program name"))})
    ]);
  }
}
