import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:stronk/api/graphql.dart';
import 'package:stronk/api/graphql/userDocument.dart';
import 'package:stronk/domain/model/user.dart';

abstract class UserRepository {
  Future<User> retrieveUser();
  Future<User> updateUserEmail(String id, String newEmail);
  Future<User> updateUsersName(String id, String newName);
}

class UserRepositoryImpl implements UserRepository {
  GraphQLUtility utility;

  UserRepositoryImpl({@required this.utility});

  @override
  Future<User> retrieveUser() async {
    // todo replace with real user fetch call
    return mockUser();
  }


  static User mockUser() {
    return new User(name: "test", email: "test@flutter.ca");
  }

  @override
  Future<User> updateUserEmail(String id, String newEmail) async {
    final MutationOptions mutationOptions = MutationOptions(documentNode: gql(UserDocument.updateUserEmail(id, newEmail)));
    final QueryResult queryResult = await utility.client.mutate(mutationOptions);
    if (queryResult.hasException) {
      log("Error updating user email ${queryResult.exception}");
    }
    final userDetails = queryResult.data['updateUser']['user'];
    return new User(name : userDetails["name"], email : userDetails["email"]);
  }

  @override
  Future<User> updateUsersName(String id, String newName) async {
    final MutationOptions mutationOptions = MutationOptions(documentNode: gql(UserDocument.updateUsersName(id, newName)));
    final QueryResult queryResult = await utility.client.mutate(mutationOptions);
    if (queryResult.hasException) {
      log("Error updating user\'s name ${queryResult.exception}");
    }
    final userDetails = queryResult.data['updateUser']['user'];
    return new User(name : userDetails["name"], email: userDetails["email"]);
  }

}
