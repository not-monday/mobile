import 'package:flutter/material.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/presentation/component/dot.dart';
import 'package:stronk/presentation/component/workout_card.dart';


class WorkoutPageView extends StatefulWidget {
  final List<Workout> workouts;
  final int currentWorkout;

  WorkoutPageView({
    Key key,
    @required this.workouts,
    @required this.currentWorkout
  }) : super(key : key);

  @override
  _WorkoutPageViewState createState() => _WorkoutPageViewState(
    workouts: workouts,
    active: currentWorkout
  );
}

class _WorkoutPageViewState extends State<WorkoutPageView> {
  List<Workout> workouts;
  int active;

  _WorkoutPageViewState({
    @required this.workouts,
    @required this.active
  });

  final controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height : 300,
          child: PageView(
            scrollDirection: Axis.horizontal,
            children: workouts.map<WorkoutCard>((workout) => WorkoutCard()).toList(),
            onPageChanged: onWorkoutScroll,
          ),
        ),
        renderPageViewIndicators()
      ]
    );
  }

  void onWorkoutScroll(int newPosition) {
    setState(() {
      active = newPosition;
    });
  }

  Widget renderPageViewIndicators() {
    int position = 0;

    return Row (
      mainAxisAlignment: MainAxisAlignment.center,
      children: workouts.map<Dot>((workout) {
        var dot = Dot(isActive : position == active);
        position ++;
        return dot;
      }).toList(),
    );
  }

}