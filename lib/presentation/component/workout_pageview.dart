import 'package:flutter/material.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/presentation/component/dot.dart';
import 'package:stronk/presentation/component/workout_card.dart';

class WorkoutCardViewPager extends StatefulWidget {
  final List<Workout> workouts;
  final int currentWorkout;
  final VoidCallback viewProgram;
  final VoidCallback viewWorkout;
  final VoidCallback viewExercise;

  WorkoutCardViewPager({
    Key key,
    @required this.workouts,
    @required this.currentWorkout,
    @required this.viewProgram,
    @required this.viewWorkout,
    @required this.viewExercise,
  }) : super(key: key);

  @override
  _WorkoutPageViewState createState() => _WorkoutPageViewState(
      workouts: workouts,
      active: currentWorkout,
      viewProgram: viewProgram,
      viewWorkout: viewWorkout,
      viewExercise: viewExercise);
}

class _WorkoutPageViewState extends State<WorkoutCardViewPager> {
  List<Workout> workouts;
  int active;
  final VoidCallback viewProgram;
  final VoidCallback viewWorkout;
  final VoidCallback viewExercise;

  _WorkoutPageViewState({
    @required this.workouts,
    @required this.active,
    @required this.viewProgram,
    @required this.viewWorkout,
    @required this.viewExercise,
  });

  final controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 315,
            child: PageView(
              scrollDirection: Axis.horizontal,
              children: workouts.map<WorkoutCard>((workout) =>
                  WorkoutCard(
                    viewExercise: viewExercise,
                  )
              ).toList(),
              onPageChanged: onWorkoutScroll,
            ),
          ),
          PageViewIndicators()
        ],
    ));
  }

  void onWorkoutScroll(int newPosition) {
    setState(() {
      active = newPosition;
    });
  }

  Widget PageViewIndicators() {
    int position = 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: workouts.map<Dot>((workout) {
        var dot = Dot(isActive: position == active);
        position++;
        return dot;
      }).toList(),
    );
  }
}
