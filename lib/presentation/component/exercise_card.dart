import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stronk/domain/model/exercise.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final bool isActive;

  ExerciseCard({
    @required this.exercise,
    this.isActive : false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      child: InkWell(
        child: Card(
          color: Colors.lightBlue[50],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.album),
                title: Text("Dumbell press"),
                subtitle: Text("workout 5/5"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}