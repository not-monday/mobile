import 'package:flutter/cupertino.dart';
import 'package:stronk/domain/model/workout.dart';

class Program {
  String name;
  List<Workout> workouts;

  Program({
    @required this.name,
    this.workouts = const [],
  });
}