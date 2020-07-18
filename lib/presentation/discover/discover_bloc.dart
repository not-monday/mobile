import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redux/redux.dart';
import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/domain/model/user.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/redux/state/app_state.dart';

// region events
abstract class _Event {}
class DiscoverEvent implements _Event {}
// endregion events


class DiscoverBloc extends Bloc<_Event, DiscoverState> {

  final WorkoutRepository workoutRepo;

  DiscoverBloc({
    @required this.workoutRepo
  });

  @override
  Stream<DiscoverState> mapEventToState(_Event event) async* {
    var newState = state;
    if (event is DiscoverEvent) {

    }

    yield newState;
  }

  @override
  DiscoverState get initialState => DiscoverState(programs: []);


}

class DiscoverState {
  final List<Program> programs;

  DiscoverState({
    @required this.programs
  });
}