import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:stronk/domain/model/user.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/redux/middleware/navigation_middleware.dart';
import 'package:stronk/redux/state/app_state.dart';

@sealed
abstract class HomeEvent {}
class ViewProgram implements HomeEvent {}
class ViewWorkout implements HomeEvent {}
class ViewExercise implements HomeEvent {}

class _HomeState {

}

class HomeVM extends Bloc<HomeEvent, _HomeState> {
  final Store<AppState> store;
  final User user;
  final Program program;

  var _state = _HomeState();

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
  _HomeState get initialState => _state;

  @override
  Stream<_HomeState> mapEventToState(HomeEvent event) async* {
    yield _state;
  }
}

