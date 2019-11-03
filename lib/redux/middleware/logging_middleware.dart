import 'package:redux/redux.dart';
import 'package:stronk/redux/state/app_state.dart';

class LoggingMiddleware extends MiddlewareClass<AppState>{
  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    print(store.state.toString() + " " + action.toString());
    next(action);
  }
}