import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/presentation/edit_workout/param_container.dart';

import 'edit_workout_bloc.dart';

enum workoutExerciseOptions {
  editWorkoutExerciseSetsAndReps,
  deleteWorkoutExerciseSet
}

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
                trailing: PopupMenuButton<workoutExerciseOptions>(
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<workoutExerciseOptions>>[
                    PopupMenuItem<workoutExerciseOptions>(
                      child: FlatButton(
                          child: Text("Edit set and reps"),
                          onPressed: () => {
                                bloc.add(new EditWorkoutExerciseSetsRepsEvent(
                                    new ParamContainer(
                                        newWeight: 20,
                                        newRepCount: 10,
                                        workoutId: workoutId,
                                        workoutExerciseId: workoutExerciseId),
                                    index))
                              }),
                    ),
                    PopupMenuItem<workoutExerciseOptions>(
                        child: FlatButton(
                            child: Text("Delete Set"),
                            onPressed: () => {
                                  bloc.add(new DeleteExerciseSetEvent(
                                      index: index,
                                      params: new ParamContainer(
                                          workoutId: workoutId,
                                          workoutExerciseId:
                                              workoutExerciseId)))
                                })),
                    PopupMenuItem<workoutExerciseOptions>(
                        child: FlatButton(
                            child: Text("Add set"),
                            onPressed: () => {
                                  bloc.add(new AddSetAndRepsEvent(
                                      params: new ParamContainer(
                                          workoutId: workoutId,
                                          workoutExerciseId: workoutExerciseId,
                                          newWeight: 10,
                                          newRepCount: 10)))
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
