import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'package:stronk/redux/reducer/app_reducer.dart';
import 'package:stronk/redux/state/app_state.dart';

class StronkHomeVM {
  final Store<AppState> store;
  final List<Navigation> pages;
  final Navigation currentPage;

  StronkHomeVM({
    @required this.store,
    @required this.pages,
    @required this.currentPage
  });

  factory StronkHomeVM.create(Store<AppState> store) => StronkHomeVM(
    store: store,
    pages: store.state.nav,
    currentPage: store.state.currentPage
  );

  void onNavItemPressed(int newPosition) {
    // only float action up if the position changed
    if (newPosition != getCurrentPosition()) {
      store.dispatch(new ChangeNavigationItemAction(pages[newPosition]));
    }
  }

  int getCurrentPosition() => pages.indexOf(currentPage);
}