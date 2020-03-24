import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stronk/domain/model/workout.dart';

class ExerciseSetCard extends StatelessWidget {
  final ExerciseSet exerciseSet;

  ExerciseSetCard({
    @required this.exerciseSet
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: EdgeInsets.symmetric(
        horizontal: 2
      ),
      child: Card(
        child : Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10
          ),
          child: ListTile(
            title: Text(
              exerciseSet.weight.toString() + " kg",
              style: TextStyle(fontWeight: FontWeight.bold),
              textScaleFactor: 1.5,
            ),
            subtitle: Text(
              "x" + exerciseSet.number.toString(),
              textScaleFactor: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}