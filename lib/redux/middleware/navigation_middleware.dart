import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:stronk/redux/state/app_state.dart';

@sealed
abstract class NavigationAction {}

class NavigationPush {
  String path;

  NavigationPush(this.path);
}


class NavigationMiddleware extends MiddlewareClass<AppState> {
  final GlobalKey<NavigatorState> navigatorKey;

  NavigationMiddleware({
    @required this.navigatorKey
  });

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    if (action is NavigationPush) {
        navigatorKey.currentState.pushNamed('/' + action.path);
    }
  }

}