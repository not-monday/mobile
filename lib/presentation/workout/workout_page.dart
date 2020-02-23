import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/presentation/component/exercise_row.dart';
import 'package:stronk/presentation/workout/workout_vm.dart';

class WorkoutPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) => BlocProvider(
    builder: (context) => WorkoutVM(
        workoutRepo : RepositoryProvider.of<WorkoutRepository>(context),
        workout: null
    ),
    child : BlocBuilder<WorkoutVM, WorkoutState>(
      builder: (context, workoutState) => Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
//              Container(
//                margin: EdgeInsets.only(bottom: 10),
//                padding: EdgeInsets.symmetric(vertical: 10),
//                child: ,
//                color: Colors.red[300],
//              ),
              Expanded(
                child: renderContent(workoutState)
              )
            ],
          )
        )
      ),
    ), create: (BuildContext context) {},
  );

  Widget renderContent(WorkoutState workoutState) {
    if (workoutState.workout == null) {
      return Container();
    }
    else {
      if (workoutState.workout.workoutExercises.isEmpty) {
        return InkWell(
          child: Text("This workout doesn't have any exercises! Would you like to add some?"),
        );
      } else {
        return ListView(
            padding: EdgeInsets.symmetric(vertical: 10),
            children : workoutState.workout.workoutExercises.map<ExerciseRow>((workoutExercise) =>
                ExerciseRow(
                  workoutExercise: workoutExercise,
                )
            ).toList()
        );
      }
    }
  }

}
