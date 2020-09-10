import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stronk/api/graphql.dart';
import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/auth_manager.dart';
import 'package:stronk/presentation/workout_actions/workout_action_bloc.dart';
import 'package:stronk/presentation/workout_actions/workout_action_card.dart';

class WorkoutActionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workoutRepository = RepositoryProvider.of<WorkoutRepository>(context);
    final graphQLUtility = RepositoryProvider.of<GraphQLUtility>(context);
    final authManager = RepositoryProvider.of<AuthManager>(context);
    return BlocProvider(
      create: (context) => WorkoutActionBloc(workoutRepo: workoutRepository, graphQLUtility: graphQLUtility, authManager: authManager),
      child: BlocBuilder<WorkoutActionBloc, WorkoutActionState>(
          builder: buildPage),
    );
  }

  Widget buildPage(BuildContext context, WorkoutActionState editWorkoutState) {
    final editWorkoutBloc = BlocProvider.of<WorkoutActionBloc>(context);
    return Scaffold(
      body: _renderWorkouts(editWorkoutBloc, editWorkoutState),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          editWorkoutBloc.add(new CreateProgramEvent(programName: "Test", description: "Test description", duration: 20))
        },
        tooltip: 'Create Program',
        child: Icon(Icons.add),
      ),
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
        //TODO dialog to ask if they'd like to add workouts to their existing
        // program
        child: Text("Author : ${editWorkoutState.programRef.author} \n"
            "program name: ${editWorkoutState.programRef.name}\n"
            "description : ${editWorkoutState.programRef.description}"  ),
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
