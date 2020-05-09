import 'package:flutter/material.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/presentation/edit_workout/edit_workout_bloc.dart';
import 'package:stronk/presentation/edit_workout/edit_workout_exercise_display.dart';

class EditWorkoutCard extends StatelessWidget {
  final Workout workout;
  final String programName;
  final EditWorkoutBloc bloc;

  EditWorkoutCard({@required this.workout, this.programName, this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      child: InkWell(
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WorkoutExercisesPage(
                      set: workout.workoutExercises,
                      workoutId: workout.id,
                      bloc: bloc)))
        },
        child: Card(
          child: Text("$programName \n"
              "${workout.id}\n"
              "${workout.description}\n"
              "${workout.workoutExercises}\n"),
        ),
      ),
    );
  }
}
