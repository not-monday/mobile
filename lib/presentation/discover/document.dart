import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stronk/domain/model/workout.dart';

part 'document.g.dart';

class DiscoverPageDocument {
  static String get() => """
  query {
      programs {
        id, name, duration, description, 
        workouts {
          id, name, description, projectedTime
        }
      }
  }
  """;
}

@JsonSerializable()
class DiscoverPageModel {
  List<Program> programs;

  DiscoverPageModel({@required this.programs});

  factory DiscoverPageModel.fromJson(Map<String, dynamic> json) => _$DiscoverPageModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiscoverPageModelToJson(this);
}
