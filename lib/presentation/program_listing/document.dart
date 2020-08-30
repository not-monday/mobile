import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stronk/domain/model/workout.dart';

part 'document.g.dart';

class DiscoverPageDocument {
  static String get(int programId) => """
  query {
      program(id: $programId) {
        id, name, duration, description, 
        workouts {
          id, name, description, projectedTime
        }
      }
  }
  """;
}

@JsonSerializable()
class ProgramListingPageModel {
  Program program;

  ProgramListingPageModel({@required this.program});

  @override
  static ProgramListingPageModel fromJson(Map<String, dynamic> json) => _$ProgramListingPageModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProgramListingPageModelToJson(this);
}
