import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'package:stronk/domain/model/program.dart';
import 'package:stronk/domain/model/user.dart';
import 'package:stronk/redux/state/app_state.dart';

class HomeVM {
  final Store<AppState> store;
  final User user;
  final Program program;

  HomeVM({
    @required this.store,
    @required this.user,
    @required this.program
  });

  factory HomeVM.create(Store<AppState> store) {
    return HomeVM(
        store : store,
        user: store.state.user,
        program: store.state.currentProgram
    );
  }
}

