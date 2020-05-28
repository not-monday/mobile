import 'package:flutter/material.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/presentation/workout_actions/workout_action_bloc.dart';
import 'package:stronk/presentation/workout_actions/workout_action_exercise_display.dart';

enum programOptions { editProgramName, addWorkout }
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
              ListTile(
                trailing: PopupMenuButton<programOptions>(
                  itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<programOptions>>[
                    PopupMenuItem<programOptions>(
                      value: programOptions.editProgramName,
                      child: FlatButton(
                          child: Text("Edit program name"),
                          onPressed: () => {
                            bloc.add(new EditProgramNameEvent("Editted program name"))
                          }
                      )
                    ),
                    PopupMenuItem<programOptions>(
                      value : programOptions.addWorkout,
                      child: FlatButton(
                        child: Text("Add workout"),
                        onPressed: () => {
                          bloc.add(new AddWorkoutEvent(workout : new Workout(
                              id: "1000",
                              name: "mock workout",
                              description: "mock description",
                              workoutExercises: [])))
                        },
                      ),
                    )
                  ]
                )
              ),
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
}
