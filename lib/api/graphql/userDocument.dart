import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stronk/domain/model/user.dart';

part 'userDocument.g.dart';

class UserDocument {
  static String queryUser(String id) => """
    query user {
       user(id : "$id") {
         name
         id
         email
       } 
    }
""";
}

@JsonSerializable()
class UserPageModel {
  User user;

  UserPageModel({@required this.user});

  factory UserPageModel.fromJson(Map<String, dynamic> json) =>
      _$UserPageModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserPageModelToJson(this);
}