import 'package:redux/redux.dart';
import 'package:stronk/redux/reducer/app_reducer.dart';
import 'package:stronk/redux/state/app_state.dart';
import 'package:stronk/repository/user_repo.dart';

class UserMiddleware extends MiddlewareClass<AppState> {
  UserRepo userRepo;

  UserMiddleware(this.userRepo);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    if (action is RetrieveUserAction) _retrieveUser(store, next);
  }

  void _retrieveUser(Store<AppState> store, next) async {
    final user = await userRepo.retrieveUser();
    store.dispatch(UserRetrievedAction(user));
  }
}