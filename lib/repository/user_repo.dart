import 'package:stronk/domain/model/user.dart';

class UserRepo {
  Future<User> retrieveUser() {
    // todo replace with real user fetch call
    return Future.value(User(name: "Test user"));
  }
}