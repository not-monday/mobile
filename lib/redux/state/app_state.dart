import 'package:flutter/cupertino.dart';
import 'package:stronk/domain/model/program.dart';
import 'package:stronk/domain/model/user.dart';

enum Navigation { Day, Search, Profile}

class AppState {
  final User user;
  final Program currentProgram;

  AppState({
    @required this.user,
    @required this.currentProgram
  });

  factory AppState.initial() => AppState(
    user: null,
    currentProgram: null
  );
}

String getTitle(Navigation nav) {
  return nav.toString().split(".").last;
}