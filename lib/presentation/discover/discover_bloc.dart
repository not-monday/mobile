import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stronk/api/graphql.dart';
import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/domain/model/workout.dart';

import 'document.dart';

// region events
abstract class _Event {}

class InitEvent implements _Event {}

class DiscoverEvent implements _Event {}
// endregion events

class DiscoverBloc extends Bloc<_Event, DiscoverState> {
  final WorkoutRepository workoutRepo;
  final GraphQLUtility graphqlUtil;

  DiscoverBloc({@required this.workoutRepo, @required this.graphqlUtil}) {
    add(new InitEvent());
  }

  @override
  Stream<DiscoverState> mapEventToState(_Event event) async* {
    var newState = state;
    if (event is InitEvent) {
      newState = await handleInit();
    }

    yield newState;
  }

  @override
  DiscoverState get initialState => DiscoverState(programs: []);

  // region event handlers
  Future<DiscoverState> handleInit() async {
    final pageModel = await graphqlUtil.makePageRequest<DiscoverPageModel>(
      DiscoverPageDocument.get(),
      (json) => DiscoverPageModel.fromJson(json)
    );
    return DiscoverState(programs: pageModel.programs);
  }
// endregion event handlers
}

class DiscoverState {
  final List<Program> programs;

  DiscoverState({@required this.programs});
}
