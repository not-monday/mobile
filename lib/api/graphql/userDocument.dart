import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stronk/domain/model/user.dart';

part 'userDocument.g.dart';

class UserDocument {
  static String queryUser(String username) => """
    query user {
       user(username : "$username") {
         username
         ... on User {
                name 
                id
                email
             }
       } 
    }
""";

  static String updateUsersName(String username, String name) => """
    mutation {
      updateUser(username : "$username", name : "$name") {
        user {
          name
          email
        }
      }
    }
  """ ;

  static String updateUserEmail(String username, String email) => """
    mutation {
      updateUser(username : "$username", email : "$email") {
        user {
          name
          email
        }
      }
    }
  """ ;
}

@JsonSerializable()
class UserPageModel {
  User user;

  UserPageModel({@required this.user});

  factory UserPageModel.fromJson(Map<String, dynamic> json) =>
      _$UserPageModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserPageModelToJson(this);
}