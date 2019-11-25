import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stronk/presentation/component/exercise_card.dart';
import 'package:stronk/presentation/workout/active_workout_vm.dart';
import 'package:stronk/presentation/workout/component/workout_completed_card.dart';
import 'package:stronk/repository/program_repo.dart';

import 'component/workout_clock.dart';

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
                  _renderCurrentExercise(
                    BlocProvider.of<ActiveWorkoutVM>(context),
                    workoutState,
                  ),
                  _renderExercises(workoutState)
                ],
              )
          )
      ),
    ),
  );

  Widget _renderCurrentExercise(ActiveWorkoutVM vm, ActiveWorkoutState workoutState) {
    final completedExerciseCount = workoutState.completedExercises.length;
    final remainingExerciseCount = workoutState.remainingExercises.length;
    final totalExerciseCount = completedExerciseCount + remainingExerciseCount + ((workoutState.currentExercise != null) ? 1 : 0);

    final exerciseCard = (workoutState.currentExercise == null)
        ? Container()
        : Dismissible(
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
          );

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: <Widget>[
          WorkoutClock(),
          exerciseCard,
          Text("Completed " + completedExerciseCount.toString() + "/" + totalExerciseCount.toString() + " exercises ")
        ],
      ),
      color: Colors.red[300],
    );
  }

  Widget _renderExercises(ActiveWorkoutState workoutState) {
    if (workoutState.loading == true) {
      return Container();
    }
    else {
      if (workoutState.currentExercise == null) {
        return InkWell(
          child: WorkoutCompletedCard()
        );
      } else {
        return Expanded(
          child: ListView(
              padding: EdgeInsets.symmetric(vertical: 10),
              children : workoutState.remainingExercises.map<ExerciseCard>((workoutExercise) =>
                  ExerciseCard(
                    workoutExercise: workoutExercise,
                  )
              ).toList()
          ),
        );
      }
    }
  }

}
