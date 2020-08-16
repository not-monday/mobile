import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:stronk/api/graphql.dart';
import 'package:stronk/api/graphql/userDocument.dart';
import 'package:stronk/domain/model/user.dart';

abstract class UserRepository {
  Future<User> retrieveUser();
  Future<User> updateUserEmail(String id, String name, String newEmail);
  Future<User> updateUsersName(String id, String newName, String email);
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
  Future<User> updateUserEmail(String id, String name, String newEmail) async {
    final MutationOptions mutationOptions = MutationOptions(documentNode: gql(UserDocument.updateUserEmail(id, newEmail)));
    final QueryResult queryResult = await utility.client.mutate(mutationOptions);
    if (queryResult.hasException) {
      log("Error fetching profile details ${queryResult.exception}");
    }
    return User(
        name: name,
        email: queryResult.data['updateUser']['user']['email']);
  }

  @override
  Future<User> updateUsersName(String id, String newName, String email) async {
    final MutationOptions mutationOptions = MutationOptions(documentNode: gql(UserDocument.updateUsersName(id, newName)));
    final QueryResult queryResult = await utility.client.mutate(mutationOptions);
    if (queryResult.hasException) {
      log("Error fetching profile details ${queryResult.exception}");
    }
    return User(
        name: queryResult.data['updateUser']['user']['name'],
        email: email);
  }

}
