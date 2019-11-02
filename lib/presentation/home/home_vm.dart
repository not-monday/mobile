import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'package:stronk/domain/model/program.dart';
import 'package:stronk/domain/model/user.dart';
import 'package:stronk/redux/reducer/app_reducer.dart';
import 'package:stronk/redux/state/app_state.dart';

class HomeVM {
  final User user;
  final Program program;
  final Function requestProgram;
  final Function requestUser;

  HomeVM({
    @required this.user,
    @required this.program,
    @required this.requestProgram,
    @required this.requestUser,
  }) {
    // initialize action to retrieve the user's current program
    requestProgram();
    requestUser();
  }

  factory HomeVM.create(Store<AppState> store) {
    return HomeVM(
        user : store.state.user,
        program: store.state.currentProgram,
        requestProgram: () => store.dispatch(new RetrieveProgramAction()),
        requestUser: () => store.dispatch(new RetrieveProgramAction())
    );
  }
}

