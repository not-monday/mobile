import 'dart:async';

import 'package:flutter/cupertino.dart';

class WorkoutClock extends StatefulWidget {

  WorkoutClock({key});

  @override
  State<StatefulWidget> createState() => _WorkoutClockState();

}

class _WorkoutClockState extends State<WorkoutClock> {
  int passedTime;

  @override
  void initState() {
    setState(() {
      passedTime = 0;
    });

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
    final minutes = passedTime/60.toInt()%60;
    final hours = passedTime/60/60.toInt()%24;

    return Text(hours.toString() + ":" + minutes.toString() + ":" + seconds.toString());
  }
}