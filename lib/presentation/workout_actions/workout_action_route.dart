import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/presentation/workout_actions/workout_action_bloc.dart';
import 'package:stronk/presentation/workout_actions/workout_action_card.dart';



class WorkoutActionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workoutRepository = RepositoryProvider.of<WorkoutRepository>(context);
    return BlocProvider(
      create: (context) => WorkoutActionBloc(workoutRepo: workoutRepository),
      child: BlocBuilder<WorkoutActionBloc, WorkoutActionState>(
          builder: buildPage),
    );
  }

  Widget buildPage(BuildContext context, WorkoutActionState editWorkoutState) {
    final editWorkoutBloc = BlocProvider.of<WorkoutActionBloc>(context);
    return Scaffold(
      body: _renderWorkouts(editWorkoutBloc, editWorkoutState),
    );
  }

  Widget _renderWorkouts(
      WorkoutActionBloc bloc, WorkoutActionState editWorkoutState) {
    if (editWorkoutState.programRef == null) {
      return Container(
        child: Text("Retrieving your workouts..!"),
      );
    } else if (editWorkoutState.programRef.workouts == []) {
      return Container(
        child: Text("No programs?"),
      );
    }
    final programRef = editWorkoutState.programRef;
    final workoutRef = editWorkoutState.workoutRef;

    return Container(
      child: ListView.builder(
        //For now set item count as 1 since there will only be one program
        itemCount: workoutRef.length,
        itemBuilder: (context, index) {
          return WorkoutActionCard(
              programName: programRef.name,
              workout: workoutRef[index],
              bloc: bloc);
        },
      ),
    );
  }
}
