import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'package:stronk/redux/state/app_state.dart';

class StronkHomeVM {
  final Store<AppState> store;
  final List<Navigation> pages;

  StronkHomeVM({
    @required this.store,
    @required this.pages,
  });

  factory StronkHomeVM.create(Store<AppState> store) => StronkHomeVM(
    store: store,
    pages: store.state.nav,
  );
}