import 'package:flutter/foundation.dart';
import 'package:stronk/api/graphql.dart';
import 'package:stronk/domain/model/user.dart';

abstract class UserRepository {
  Future<User> retrieveUser();
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
}
