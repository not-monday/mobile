import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/presentation/active_workout/active_workout_route.dart';
import 'package:stronk/presentation/component/greeting_card.dart';
import 'package:stronk/presentation/component/program_card.dart';
import 'package:stronk/presentation/component/workout_pageview.dart';
import 'package:stronk/redux/state/app_state.dart';

import 'home_vm.dart';

/// the home route displays an overview of the remaining workouts this week
/// and should also include additional heplful quick links to other routes
class HomeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeBloc>(
      converter: (Store<AppState> store) => HomeBloc.create(store),
      builder: (BuildContext context, HomeBloc homeBloc) => BlocProvider(
          create: (context) => homeBloc,
          child: BlocBuilder<HomeBloc, HomeState>(
              builder: (BuildContext context, HomeState state) => buildAppUI(context, homeBloc, state))),
    );
  }

  Widget buildAppUI(BuildContext context, HomeBloc homeBloc, HomeState state) {
    final mockWorkouts = [Workout(id: "1"), Workout(id: "1"), Workout(id: "1"), Workout(id: "1"), Workout(id: "1")];

    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: <Widget>[
                    GreetingCard(name: state.userDisplayName),
                    WorkoutCardViewPager(
                      workouts: mockWorkouts,
                      currentWorkout: 0,
                      // TODO don't use direct navigation
                      viewProgram: () =>
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ActiveWorkoutRoute())),
                      viewWorkout: () =>
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ActiveWorkoutRoute())),
                      viewExercise: () =>
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ActiveWorkoutRoute())),
                    ),
                  ],
                ),
                color: Colors.red[300],
              ),
              Text("hello"),
              if (homeBloc.program != null) ProgramCard(homeBloc.program),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Increment',
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}
