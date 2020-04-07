import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/domain/model/record.dart';
import 'package:stronk/presentation/active_workout/active_workout_bloc.dart';
import 'package:stronk/presentation/component/current_exercise_card.dart';
import 'package:stronk/presentation/component/exercise_row.dart';

import 'component/workout_clock.dart';

class ActiveWorkoutRoute extends StatelessWidget {
  final appbarBackground = Colors.red[300];
  final appBarHighlight = Colors.red[100];

  @override
  Widget build(BuildContext context) {
    final workoutRepo = RepositoryProvider.of<WorkoutRepository>(context);

    return BlocProvider(
      create: (context) => ActiveWorkoutBloc(workoutRepo: workoutRepo),
      child: BlocBuilder<ActiveWorkoutBloc, ActiveWorkoutState>(
          // separating the rendering of the page is much cleaner
          builder: buildPage),
    );
  }

  Widget buildPage(BuildContext context, ActiveWorkoutState workoutState) {
    final activeWorkoutBloc = BlocProvider.of<ActiveWorkoutBloc>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: buildAppbar(activeWorkoutBloc, workoutState),
          body: Column(children: [
            _renderTabBarView(workoutState),
          ])),
    );
  }

  Widget buildAppbar(ActiveWorkoutBloc bloc, ActiveWorkoutState workoutState) {
    var remainingTabText = "Remaining (${workoutState.remainingExerciseCount})";
    var completedTabText = "Completed (${workoutState.completedExerciseCount})";

    return PreferredSize(
      preferredSize: Size.fromHeight(220.0),
      child: AppBar(
        backgroundColor: appbarBackground,
        flexibleSpace: Center(
          child: _renderHeader(bloc, workoutState),
        ),
        bottom: TabBar(
          labelPadding: EdgeInsets.all(16),
          indicatorColor: appBarHighlight,
          indicatorWeight: 4.0,
          indicatorPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            Text(remainingTabText),
            Text(completedTabText),
          ],
        ),
      ),
    );
  }

  // widget for rendering the "current" workout header
  Widget _renderHeader(ActiveWorkoutBloc bloc, ActiveWorkoutState workoutState) {
    if (workoutState.workoutRef == null)
      return Container(child: Text("Retrieving workout")); // TODO show workout completed card

    // TODO create "completed exercise view
    if (workoutState.completed) return Container(child: Text("Completed Workout!"));

    final currentExercise = workoutState.exerciseRecords[workoutState.currentExerciseIndex];
    final currentSet = currentExercise.exerciseSets[workoutState.currentSetIndex];

    final exerciseCard = (workoutState.workoutRef == null) // TODO show workout completed card
        ? Container(child: Text("Retrieving workout"))
        : Dismissible(
            key: UniqueKey(),
            child: CurrentExerciseCard(workoutExercise: currentExercise, exerciseSet: currentSet),
            onDismissed: (direction) {
              // left swipe
              if (direction == DismissDirection.endToStart) {
                // TODO add popup for selecting reps before failure
                bloc.add(new FailExerciseEvent(0));
              }
              // right swipe
              else if (direction == DismissDirection.startToEnd) {
                bloc.add(new CompleteExerciseEvent());
              }
            },
          );

    return Container(
      height: 210,
      padding: EdgeInsets.only(top: 40),
      child: Column(
        children: <Widget>[
          WorkoutClock(),
          Container(height: 100, child: exerciseCard),
        ],
      ),
      color: Colors.red[300],
    );
  }

  Widget _renderTabBarView(ActiveWorkoutState workoutState) {
    if (workoutState.workoutRef == null)
      return Expanded(
          child: TabBarView(
        children: [Text("loading"), Text("loading")],
      ));

    // TODO add widget to display workout completed
//    if (workoutState.completed)

    final remainingFilter = (setRecord) => setRecord.status == Status.Incomplete;
    final completedFilter = (setRecord) => setRecord.status != Status.Incomplete;

    final remainingExercisePage =
        _renderExercisePage("Remaining", workoutState.exerciseRecords, workoutState.setRecords, remainingFilter);
    final completedExercisePage =
        _renderExercisePage("Completed", workoutState.exerciseRecords, workoutState.setRecords, completedFilter);

    // TODO render workout completed card on remaining exercises screen
    return Expanded(child: TabBarView(children: [remainingExercisePage, completedExercisePage]));
  }

  Widget _renderExercisePage(
      title, List<ExerciseRecord> exercises, List<List<SetRecord>> sets, bool filter(SetRecord e)) {
    var setIndex = 0;
    final exerciseCards = exercises
        .map((exercise) {
          // get the list of set records satisfying predicate and create a new
          // exercise record using only those sets
          final setRecords = sets[setIndex].where(filter).toList();
          setIndex += 1;

          return ExerciseRow(
            workoutExercise: exercise,
            setRecords: setRecords,
          );
        })
        .where((exerciseRow) => exerciseRow.setRecords.isNotEmpty)
        .toList();

    return Container(
      child: ListView(padding: EdgeInsets.symmetric(vertical: 10), children: exerciseCards),
    );
  }
}
