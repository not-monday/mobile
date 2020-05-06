import 'package:flutter/cupertino.dart';
import 'package:stronk/auth_manager.dart';
import 'package:stronk/domain/model/user.dart';
import 'package:stronk/domain/model/workout.dart';

enum Navigation { Day, Search, Profile}

class AppState {
  final User user;
  final Account account;
  final Program currentProgram;

  AppState({
    @required this.user,
    @required this.account,
    @required this.currentProgram,
  });

  factory AppState.initial() => AppState(
    user: null,
    currentProgram: null
  );
}

String getTitle(Navigation nav) {
  return nav.toString().split(".").last;
}