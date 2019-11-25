import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stronk/domain/model/workout.dart';

class ExerciseCard extends StatelessWidget {
  final WorkoutExercise workoutExercise;
  final bool isActive;

  final verticalSpacing = 2.0;
  final horizontalSpacing = 10.0;
  final background = Colors.lightBlue[50];

  ExerciseCard({
    @required this.workoutExercise,
    this.isActive : false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: verticalSpacing,
          horizontal: horizontalSpacing
      ),
      child: InkWell(
        child: Card(
          color: background,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.album),
                title: Text(
                  "Dumbell press",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(workoutExercise.),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActiveExerciseCard extends ExerciseCard {
  final verticalSpacing = 4.0;
  final horizontalSpacing = 20.0;
  final background = Colors.red[50];
}