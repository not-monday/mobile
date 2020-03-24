import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stronk/domain/model/record.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/presentation/component/exercise_set_card.dart';

class ExerciseRow extends StatelessWidget {
  final WorkoutExercise workoutExercise;
  final bool isActive;
  final List<SetRecord> setRecords;

  final verticalSpacing = 2.0;
  final horizontalSpacing = 10.0;
  final background = Colors.lightBlue[50];

  ExerciseRow(
      {@required this.workoutExercise,
      @required this.setRecords,
      this.isActive: false});

  @override
  Widget build(BuildContext context) {
    final remainingCount = setRecords
        .where((setRecord) => setRecord.status == Status.Incomplete)
        .length;

    final remainingExercises = setRecords
        .map((exerciseSet) => ExerciseSetCard(exerciseSet: exerciseSet))
        .toList();

    if (isActive) {
      remainingExercises.removeAt(0);
    }

    return Container(
      margin: EdgeInsets.symmetric(
          vertical: verticalSpacing, horizontal: horizontalSpacing),
      child: InkWell(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  workoutExercise.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 1.2,
                ),
                subtitle: Text("$remainingCount/${workoutExercise.exerciseSets.length} remaining"),
              ),
              // row of set records
              Container(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: remainingExercises,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
