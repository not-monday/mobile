import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkoutCompletedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: EdgeInsets.only(
        top : 50,
        left: 30,
        right: 30,
      ),
      child: InkWell(
        child: Card(
          color: Colors.red[300],
          child: Padding(
            padding: EdgeInsets.only(
              top : 30,
              left: 10,
              right: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.album),
                  title: Text(
                    "Workout Completed!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textScaleFactor: 2,
                  ),
                  subtitle: Text(
                    "workout 5/5",
                    textScaleFactor: 1.7,
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}