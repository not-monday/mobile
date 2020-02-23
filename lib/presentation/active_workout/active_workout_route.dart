import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/domain/model/record.dart';
import 'package:stronk/presentation/active_workout/active_workout_bloc.dart';
import 'package:stronk/presentation/component/current_exercise_card.dart';
import 'package:stronk/presentation/component/exercise_card.dart';

import 'component/workout_clock.dart';

class ActiveWorkoutRoute extends StatelessWidget {

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

  // widget for rendering the "current" workout header
  Widget _renderCurrentExercise(ActiveWorkoutBloc bloc, ActiveWorkoutState workoutState) {
    if (workoutState.workoutRef == null) return Container(child: Text("Retrieving workout")); // TODO show workout completed card

    var completedExerciseCount = 0;
    var remainingExerciseCount = 0;

    if (workoutState.exerciseRecords != null) {
      remainingExerciseCount = workoutState.exerciseRecords
          .where((exercise) => exercise.status == Status.Incomplete)
          .length;

      completedExerciseCount = workoutState.exerciseRecords
          .where((exercise) => exercise.status != Status.Incomplete)
          .length;
    }

    final currentExercise = workoutState.exerciseRecords[workoutState.currentExerciseIndex];
    final currentSet = currentExercise.exerciseSets[workoutState.currentSetIndex];

    final totalExerciseCount = completedExerciseCount + remainingExerciseCount;
    final exerciseCard = (workoutState.workoutRef == null) // TODO show workout completed card
        ? Container(
          child: Text("Retrieving workout")
        )
        : Dismissible(
            key: UniqueKey(),
            child : CurrentExerciseCard(workoutExercise: currentExercise, exerciseSet : currentSet),
            onDismissed: (direction){
              // left swipe
              if (direction == DismissDirection.endToStart) {
                // TODO add popup for current exercise
                // bloc.add(new FailExerciseEvent());
              }
              // right swipe
              else if (direction == DismissDirection.startToEnd) {
                bloc.add(new CompleteExerciseEvent());
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
  
    final remainingFilter = (setRecord)=>setRecord.status == Status.Incomplete;
    final completedFilter = (setRecord)=>setRecord.status != Status.Incomplete;


    final remainingExercisePage = _renderExercisePage(workoutState.exerciseRecords, workoutState.setRecords, remainingFilter);
    final completedExercisePage = _renderExercisePage(workoutState.exerciseRecords, workoutState.setRecords,completedFilter);

    // TODO render workout completed cart on remaining exercises screen
    // WorkoutCompletedCard

    return Column();
  }

  Widget _renderExercisePage(List<ExerciseRecord> exercises,List<List<SetRecord>> sets, bool filter(SetRecord e)) {
    var setIndex = 0;
    final remainingExercisesCards = exercises
      .map((exercise) {
        // get the list of remaining set records associated with this exercise
        final setRecords = sets[setIndex].where(filter).toList();
        setIndex += 1; 

        return new ExerciseCard(
          workoutExercise: exercise,
          setRecords: setRecords, 
        );
      }).toList();
   
    return Expanded(
      child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10),
          children : remainingExercisesCards
      ),
    );
  }
}
