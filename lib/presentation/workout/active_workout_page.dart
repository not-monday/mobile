import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stronk/presentation/component/exercise_card.dart';
import 'package:stronk/presentation/workout/active_workout_vm.dart';
import 'package:stronk/repository/program_repo.dart';

class ActiveWorkoutPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) => BlocProvider(
    builder: (context) => ActiveWorkoutVM(
        programRepo : RepositoryProvider.of<ProgramRepository>(context),
    ),
    child : BlocBuilder<ActiveWorkoutVM, ActiveWorkoutState>(
      builder: (context, workoutState) => Scaffold(
          body: Center(
              child: Column(
                children: <Widget>[
                  renderCurrentExercise(
                    BlocProvider.of<ActiveWorkoutVM>(context),
                    workoutState,
                  ),
                  Expanded(
                      child: renderExercises(workoutState)
                  )
                ],
              )
          )
      ),
    ),
  );

  Widget renderCurrentExercise(ActiveWorkoutVM vm, ActiveWorkoutState workoutState) {
    if (workoutState.currentExercise != null) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: <Widget>[
            Text("1:34"),
            Dismissible(
              key: UniqueKey(),
              child : ExerciseCard(workoutExercise: workoutState.currentExercise, isActive: true,),
              onDismissed: (direction) => {
                // left swipe
                if (direction == DismissDirection.endToStart) {
                  vm.add(ActiveWorkoutEvent.FailedWorkoutExercise)
                }
                // right swipe
                else if (direction == DismissDirection.startToEnd) {
                  vm.add(ActiveWorkoutEvent.CompleteWorkoutExercise)
                }
              },
            ),
          ],
        ),
        color: Colors.red[300],
      );
    } else {
      return Container();
    }
  }

  Widget renderExercises(ActiveWorkoutState workoutState) {
    if (workoutState.loading == true) {
      return Container();
    }
    else {
      if (workoutState.remainingExercises.isEmpty) {
        return InkWell(
          child: Text("That's it! You're done for today :)"),
        );
      } else {
        return ListView(
            padding: EdgeInsets.symmetric(vertical: 10),
            children : workoutState.remainingExercises.map<ExerciseCard>((workoutExercise) =>
                ExerciseCard(
                  workoutExercise: workoutExercise,
                )
            ).toList()
        );
      }
    }
  }

}
