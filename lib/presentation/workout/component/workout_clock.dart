import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkoutClock extends StatefulWidget {

  WorkoutClock({key});

  @override
  State<StatefulWidget> createState() => _WorkoutClockState();
}

class _WorkoutClockState extends State<WorkoutClock> {
  int passedTime = 0;

  @override
  void initState() {

    Timer.periodic(Duration(seconds: 1), (Timer t) => {
      // update the number of seconds that have passed
      setState(() {
        passedTime += 1;
      })
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final seconds = passedTime%60;
    final minutes = passedTime~/60%60;
    final hours = passedTime/60~/60%24;
    final timeText = hours.toString() + ":" + minutes.toString() + ":" + seconds.toString();

    return Text(
      timeText,
      textScaleFactor: 2,
      style: TextStyle(color: Colors.white),
    );
  }
}