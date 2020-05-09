import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/presentation/component/edit_workout_card.dart';
import 'package:stronk/presentation/edit_workout/edit_workout_bloc.dart';

class EditWorkoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workoutRepository = RepositoryProvider.of<WorkoutRepository>(context);
    return BlocProvider(
      create: (context) => EditWorkoutBloc(workoutRepo: workoutRepository),
      child: BlocBuilder<EditWorkoutBloc, EditWorkoutState>(builder: buildPage),
    );
  }

  Widget buildPage(BuildContext context, EditWorkoutState editWorkoutState) {
    final editWorkoutBloc = BlocProvider.of<EditWorkoutBloc>(context);
    return Scaffold(
      body: _renderWorkouts(editWorkoutBloc, editWorkoutState),
    );
  }

  Widget _renderWorkouts(
      EditWorkoutBloc bloc, EditWorkoutState editWorkoutState) {
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
          return EditWorkoutCard(
              programName: programRef.name,
              workout: workoutRef[index],
              bloc: bloc);
        },
      ),
    );
  }
}
