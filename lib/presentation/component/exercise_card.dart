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
    final remainingCount = workoutExercise.exerciseSets.where((exerciseSet) => !exerciseSet.completed).length;
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
                  workoutExercise.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 1.2,
                ),
                subtitle: Text(
                    remainingCount.toString() + "/" + workoutExercise.exerciseSets.length.toString() + " remaining"
                ),
              ),
              Container(
                height: 100,
                child : ListView(
                    scrollDirection: Axis.horizontal,
                    children: workoutExercise.exerciseSets
                        .where((exerciseSet) => !exerciseSet.completed)
                        .map((exerciseSet) => ExerciseSetCard(exerciseSet: exerciseSet)
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