import 'package:flutter/cupertino.dart';
import 'package:stronk/domain/model/exercise.dart';

class Workout {
  String id;
  List<Exercise> exercises;

  Workout({
    @required this.id,
    this.exercises = const [],
  });

}