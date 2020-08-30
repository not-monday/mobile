import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stronk/api/graphql.dart';
import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/domain/model/workout.dart';

import 'document.dart';

class ProgramListingBloc extends Bloc<_Event, ProgramListingState> {
  final WorkoutRepository workoutRepo;
  final GraphQLUtility graphqlUtil;
  final int programId;

  ProgramListingBloc({@required this.workoutRepo, @required this.graphqlUtil, @required this.programId}) {
    add(new InitEvent());
  }

  @override
  ProgramListingState get initialState => ProgramListingState(program: null);

  @override
  Stream<ProgramListingState> mapEventToState(_Event event) async* {
    var newState = state;
    if (event is InitEvent) {
      newState = await handleInit();
    }
    yield newState;
  }

  // region event handlers
  Future<ProgramListingState> handleInit() async {
    final pageModel = await graphqlUtil.makePageRequest<ProgramListingPageModel>(
        DiscoverPageDocument.get(programId), ProgramListingPageModel.fromJson);
    return ProgramListingState(program: pageModel.program);
  }
// endregion event handlers
}

// region events
abstract class _Event {}

class InitEvent implements _Event {}

// endregion events

class ProgramListingState {
  final Program program;

  ProgramListingState({@required this.program});
}
