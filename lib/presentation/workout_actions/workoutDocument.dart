import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stronk/domain/model/workout.dart';

part 'workoutDocument.g.dart';

class WorkoutDocument {
  static String queryWorkouts(int id) => """
    
  """;

  static String queryWorkout(int id) => """
    workout(id: $id) {
      id, name, description, projectedTime, 
      workoutExercises {
        workoutId, exerciseId, workoutReps, workoutWeights, restTime,
        exercise {
          id, name, description
        }
      }
    }
  """;

  static String getQueryProgram(String id) => """
   query {
      user(id : "$id") {
         currentProgram {
            id, description
            workouts {
               id, description, projectedTime
            }
         }
      } 
   }
   """;
}

@JsonSerializable()
class WorkoutPageModel {
  Program program;

  WorkoutPageModel({@required this.program});

  factory WorkoutPageModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutPageModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutPageModelToJson(this);
}
