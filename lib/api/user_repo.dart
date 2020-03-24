import 'package:stronk/domain/model/user.dart';

class UserRepo {
  Future<User> retrieveUser() async {
    // todo replace with real user fetch call
    return User(name: "Test user");
  }
}