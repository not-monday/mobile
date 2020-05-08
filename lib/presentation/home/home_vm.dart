import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:stronk/domain/model/user.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/redux/middleware/navigation_middleware.dart';
import 'package:stronk/redux/state/app_state.dart';

import '../../auth_manager.dart';

@sealed
abstract class HomeEvent {}
class ViewProgram implements HomeEvent {}
class ViewWorkout implements HomeEvent {}
class ViewExercise implements HomeEvent {}

class HomeState {
  String userDisplayName;

  HomeState({
    @required this.userDisplayName
  });
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final Store<AppState> store;
  final User user;
  final Program program;
  final Account account;

  HomeBloc({
    @required this.store,
    @required this.user,
    @required this.account,
    @required this.program
  });

  factory HomeBloc.create(Store<AppState> store) {
    return HomeBloc(
        store : store,
        user: store.state.user,
        account : store.state.account,
        program: store.state.currentProgram
    );
  }

  void interact(HomeEvent event) {
    if (event is ViewProgram) {
      store.dispatch(NavigationPush("program"));
    } else if (event is ViewWorkout) {
      store.dispatch(NavigationPush("workout"));
    } else if (event is ViewExercise) {
      store.dispatch(NavigationPush("exercise"));
    }
  }

  @override
  HomeState get initialState => HomeState(
    userDisplayName: account.name
  );

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    yield state;
  }
}

