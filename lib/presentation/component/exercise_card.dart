import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/presentation/component/exercise_set_card.dart';

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
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: 2,
              horizontal: 2
          ),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  "Dumbell press",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 1.2,
                ),
                subtitle: Text(
                  "3/5 remaining"
                ),
              ),
              Container(
                height: 100,
                child : ListView(
                    scrollDirection: Axis.horizontal,
                    children: workoutExercise.exerciseSets.map(
                        (ExerciseSet exerciseSet) => ExerciseSetCard(exerciseSet: exerciseSet)
                    ).toList()
                ),
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