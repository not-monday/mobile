import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stronk/presentation/component/exercise_card.dart';
import 'package:stronk/presentation/workout/workout_vm.dart';
import 'package:stronk/repository/program_repo.dart';

class WorkoutPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) => BlocProvider(
    builder: (context) => WorkoutVM(
        programRepo : RepositoryProvider.of<ProgramRepository>(context),
        workout: null
    ),
    child : BlocBuilder<WorkoutVM, WorkoutState>(
      builder: (context, workoutState) => Scaffold(
        body: Center(
          child: renderContent(workoutState)
        )
      ),
    ),
  );

  Widget renderContent(WorkoutState workoutState) {
    if (workoutState.workout == null) {
      return Container();
    }
    else {
      if (workoutState.workout.exercises.isEmpty) {
        return InkWell(
          child: Text("This workout doesn't have any exercises! Would you like to add some?"),
        );
      } else {
        return Column(
            children : workoutState.workout.exercises.map<ExerciseCard>((exercise) =>
                ExerciseCard(
                  exercise: exercise,
                )
            ).toList()
        );
      }
    }
  }

}
