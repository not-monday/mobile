import 'package:flutter/material.dart';
import 'package:stronk/presentation/component/workout_label.dart';
import 'package:stronk/presentation/edit_workout/edit_workout_route.dart';

class WorkoutCard extends StatelessWidget {
  final VoidCallback viewWorkout;

  WorkoutCard({
    @required this.viewWorkout,
  });

  @override
  Widget build(BuildContext context) {
    final buttonBarThemeData = new ButtonBarThemeData();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      child: InkWell(
        onTap: () => viewWorkout(),
        child: Card(
          color: Colors.lightBlue[50],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.album),
                title: Text("Monday workout"),
                subtitle: Text("workout 5/5"),
                trailing: new IconButton(
                    icon: Icon(Icons.mode_edit),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditWorkoutPage()));
                    }),
              ),
              Column(
                children: <Widget>[
                  WorkoutLabel(workout: "DUMBELL LIFTS", sets: 5, reps: 12),
                  WorkoutLabel(workout: "DUMBELL LIFTS", sets: 5, reps: 12),
                  WorkoutLabel(workout: "DUMBELL LIFTS", sets: 5, reps: 12),
                  WorkoutLabel(workout: "DUMBELL LIFTS", sets: 5, reps: 12),
                ],
              ),
              ButtonBarTheme(
                // make buttons use the appropriate styles for cards
                child: ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: const Text('VIEW WORKOUT'),
                      onPressed: () => viewWorkout(),
                    ),
                  ],
                ),
                data: buttonBarThemeData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
