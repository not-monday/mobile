import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:stronk/presentation/component/exercise_card.dart';
import 'package:stronk/presentation/workout/workout_vm.dart';
import 'package:stronk/redux/state/app_state.dart';

class WorkoutRoute extends StatelessWidget{
  @override
  Widget build(BuildContext context) => StoreConnector<AppState, WorkoutVM>(
    converter: (Store<AppState> store) => WorkoutVM.create(store),
    builder: (BuildContext context, WorkoutVM workoutVM)=> Scaffold(
      body: Center(
        child: renderContent(workoutVM)
      ),
    ),
  );


  Widget renderContent(WorkoutVM workoutVM) {
    if (workoutVM.workout.exercises.isEmpty) {
      return InkWell(
        child: Text("Test exercise"),
      );
    } else {
      return Column(
        children : workoutVM.workout.exercises.map<ExerciseCard>((exercise) =>
          ExerciseCard(
            exercise: exercise,
          )
        ).toList()
      );
    }
  }


}
