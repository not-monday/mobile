import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/presentation/edit_workout/edit_workout_bloc.dart';
import 'package:stronk/presentation/edit_workout/edit_workout_exerciseSetDisplay.dart';

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
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
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
            title: Text("$workoutId\n"
                "${workoutExercise.id},\n"
                "${workoutExercise.exerciseSets}"),
          ),
        ),
      ),
    );
  }
}
