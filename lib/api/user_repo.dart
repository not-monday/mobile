import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:stronk/api/graphql.dart';
import 'package:stronk/domain/model/user.dart';
import 'package:stronk/api/graphql/userDocument.dart';

abstract class UserRepository {
  Future<User> retrieveUser();

  Future<User> retrieveUserById(String id);
}

class UserRepositoryImpl implements UserRepository {
  GraphQLUtility utility;

  UserRepositoryImpl({@required this.utility});

  @override
  Future<User> retrieveUser() async {
    // todo replace with real user fetch call
    return mockUser();
  }

  @override
  Future<User> retrieveUserById(String id) async {
    final QueryOptions options =
        QueryOptions(documentNode: gql(queryUser(id)));

    final QueryResult queryResult = await utility.client.query(options);
    if (queryResult.hasException) {
      log("Error fetching profile details ${queryResult.exception}");
    }
    return User(
        name: queryResult.data['user']['name'],
        email: queryResult.data['user']['email']);
  }

  static User mockUser() {
    return User(name: "test", email: "test@flutter.ca");
  }
}
