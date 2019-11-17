
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WorkoutLabel extends StatelessWidget {
  final String workout;
  final int sets;
  final int reps;

  WorkoutLabel({
    @required this.workout,
    @required this.sets,
    @required this.reps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row (
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child : Text(
              workout,
              textScaleFactor: 1.1,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
          ),
          Text(sets.toString()),
          Text(" x "),
          Text(reps.toString()),
        ],
      )
    );
  }
}