import 'package:flutter/cupertino.dart';
import 'package:stronk/auth_manager.dart';
import 'package:stronk/domain/model/user.dart';
import 'package:stronk/domain/model/workout.dart';

enum Navigation { Day, Discover, Profile}

enum ScreenState { Loading, LoginRequired, Ready }

@immutable
class AppState {
  final ScreenState screenState;
  final User user;
  final Account account;
  final Program currentProgram;

  AppState({
    @required this.screenState,
    @required this.user,
    @required this.account,
    @required this.currentProgram,
  });

  factory AppState.initial() => AppState(
    screenState: ScreenState.Loading,
    user: null,
    account: null,
    currentProgram: null
  );
}

String getTitle(Navigation nav) {
  return nav.toString().split(".").last;
}