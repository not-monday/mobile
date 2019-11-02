import 'package:stronk/redux/state/app_state.dart';

AppState appReducer(AppState state, dynamic action) {
  return new AppState(
    user : null,
    nav : state.nav,
    currentPage : navigationReducer(state.currentPage, action),
  );
}

Navigation navigationReducer(nav, action) {
  return action.selected;
}

// region app actions

class ChangeNavigationItemAction {
  final Navigation selected;

  ChangeNavigationItemAction(this.selected);
}


class UpdateCurrentUserAction {}

// endregion app actions