import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/presentation/component/greeting_card.dart';
import 'package:stronk/presentation/component/program_card.dart';
import 'package:stronk/presentation/component/workout_pageview.dart';
import 'package:stronk/redux/state/app_state.dart';

import 'home_vm.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StoreConnector<AppState, HomeVM> (
    converter: (Store<AppState> store) => HomeVM.create(store),
    builder: (BuildContext context, HomeVM homeVM) => Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: <Widget>[
                  GreetingCard(),
                  WorkoutPageView(
                    workouts: [Workout(), Workout(), Workout(), Workout(), Workout()],
                    currentWorkout: 0,
                  ),
                ],
              ),
              color: Colors.red[300],
            ),

            if (homeVM.program != null) ProgramCard(homeVM.program),
          ],

        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>{},
        tooltip: 'Increment',
        child: Icon(Icons.arrow_forward),
      ),
    ),
  );
}