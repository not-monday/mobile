import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stronk/domain/model/workout.dart';

class CurrentExerciseCard extends StatelessWidget {
  final verticalSpacing = 4.0;
  final horizontalSpacing = 20.0;
  final background = Colors.red[50];

  final WorkoutExercise workoutExercise;
  final ExerciseSet exerciseSet;

  CurrentExerciseCard({
    @required this.workoutExercise,
    @required this.exerciseSet
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(
            vertical: verticalSpacing,
            horizontal: horizontalSpacing
        ),
        child: Card(
          child : InkWell(
            child: ListTile(
              title: Text(
                workoutExercise.name,
                style: TextStyle(fontWeight: FontWeight.bold),
                textScaleFactor: 1.4,
              ),
              subtitle: Text(
                  exerciseSet.weight.toString() + "lb x " + exerciseSet.number.toString(),
                  textScaleFactor: 1.2,
              ),
            ),
          )
        )
    );
  }

}