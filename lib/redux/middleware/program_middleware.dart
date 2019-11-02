import 'package:redux/redux.dart';
import 'package:stronk/redux/reducer/app_reducer.dart';
import 'package:stronk/redux/state/app_state.dart';
import 'package:stronk/repository/program_repo.dart';

class ProgramMiddleware extends MiddlewareClass<AppState>{
  ProgramRepository programRepo;

  ProgramMiddleware(this.programRepo);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    if (action is RetrieveProgramAction) _fetchProgram(next);
  }

  void _fetchProgram(NextDispatcher next) async {
    final program = await programRepo.retrieveProgram();
    next(new ProgramRetrievedAction(program));
  }
}

