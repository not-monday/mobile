import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:stronk/api/graphql.dart';
import 'package:stronk/domain/model/user.dart';

abstract class UserRepository {
  Future<User> retrieveUser();
}

class UserRepositoryImpl implements UserRepository {
  GraphQLUtility utility;

  UserRepositoryImpl({@required GraphQLUtility utility});

  @override
  Future<User> retrieveUser() async {
    // todo replace with real user fetch call
    const String readUsers = r''' 
       query {
         user(id:"user_id_1") {
           name
           id
           email
         } 
       }
    ''';
    final QueryOptions options = QueryOptions(
      documentNode: gql(readUsers)
    );
    final QueryResult queryResult = await utility.client.queryManager.query(options);
    if (queryResult.hasException) {
      print(queryResult.exception.toString());
    }


    return User(name: "test");
  }
}
