import 'package:flutter/material.dart';
import 'package:stronk/presentation/component/workout_label.dart';

class WorkoutCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      child: Card(
        color: Colors.lightBlue[50],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.album),
              title: Text("Monday workout"),
              subtitle: Text("workout 5/5"),
            ),
            Column(
              children: <Widget>[
                WorkoutLabel(workout : "DUMBELL LIFTS", sets: 5, reps: 12),
                WorkoutLabel(workout : "DUMBELL LIFTS", sets: 5, reps: 12),
                WorkoutLabel(workout : "DUMBELL LIFTS", sets: 5, reps: 12),
                WorkoutLabel(workout : "DUMBELL LIFTS", sets: 5, reps: 12),
              ],
            ),
            ButtonTheme.bar( // make buttons use the appropriate styles for cards
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('VIEW WORKOUT'),
                    onPressed: () { /* ... */ },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}