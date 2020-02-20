import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/presentation/active_workout/active_workout_bloc.dart';
import 'package:stronk/presentation/component/current_exercise_card.dart';
import 'package:stronk/presentation/component/exercise_card.dart';

import 'component/workout_clock.dart';

class ActiveWorkoutPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) {
      final workoutRepo = RepositoryProvider.of<WorkoutRepository>(context);
      return ActiveWorkoutBloc(workoutRepo : workoutRepo);
    },
    child : BlocBuilder<ActiveWorkoutBloc, ActiveWorkoutState>(
      builder: (context, workoutState) => Scaffold(
          body: Center(
              child: Column(
                children: <Widget>[
                  _renderCurrentExercise(
                    BlocProvider.of<ActiveWorkoutBloc>(context),
                    workoutState,
                  ),
                  _renderExercisesViewPager(workoutState)
                ],
              )
          )
      ),
    ),
  );

  Widget _renderCurrentExercise(ActiveWorkoutBloc bloc, ActiveWorkoutState workoutState) {
    // var completedExerciseCount = 0;
    // var remainingExerciseCount = 0;

    // if (workoutState.exercises != null) {
    //   completedExerciseCount = workoutState.exercises
    //       .where((exercise) => exercise.completed)
    //       .length;

    //   remainingExerciseCount = workoutState.exercises
    //       .where((exercise) => !exercise.completed)
    //       .length;
    // }

    final totalExerciseCount = completedExerciseCount + remainingExerciseCount + ((workoutState.currentExercise != null) ? 1 : 0);
    final exerciseCard = (workoutState.currentSet == null)
        ? Container() // TODO show workout completed card
        : Dismissible(
            key: UniqueKey(),
            child : CurrentExerciseCard(workoutExercise: workoutState.currentExercise, exerciseSet : workoutState.currentSet),
            onDismissed: (direction) => {
              // left swipe
              if (direction == DismissDirection.endToStart) {
                vm.add(ActiveWorkoutEvent.FailSet)
              }
              // right swipe
              else if (direction == DismissDirection.startToEnd) {
                vm.add(ActiveWorkoutEvent.CompleteSet)
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

  Widget _renderExercisesViewPager(ActiveWorkoutState workoutState) {
    if (workoutState.workoutRef == null) return Container();
  
      return Expanded(
        child: ListView(
            padding: EdgeInsets.symmetric(vertical: 10),
            children : workoutState.exercises
              .where((exercise) => !exercise.completed)
              .map((workoutExercise) => ExerciseCard(
                workoutExercise: workoutExercise,
                isActive: workoutExercise == workoutState.currentExercise
              ))
              .toList()
        ),
      );
    
    // TODO render workout completed cart on remaining exercises screen
    // WorkoutCompletedCard
  }

}
