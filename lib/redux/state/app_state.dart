import 'package:flutter/cupertino.dart';
import 'package:stronk/domain/model/program.dart';
import 'package:stronk/domain/model/user.dart';

enum Navigation { Day, Search, Profile}

class AppState {
  final User user;
  final List<Navigation> nav;
  final Program currentProgram;

  AppState({
    @required this.user,
    @required this.nav,
    @required this.currentProgram
  });

  factory AppState.initial() => AppState(
    user: null,
    nav : [Navigation.Day, Navigation.Search, Navigation.Profile],
    currentProgram: null
  );
}

String getTitle(Navigation nav) {
  return nav.toString().split(".").last;
}