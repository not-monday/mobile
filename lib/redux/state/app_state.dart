import 'package:flutter/cupertino.dart';
import 'package:stronk/domain/model/user.dart';

enum Navigation { Day, Search, Profile}

class AppState {
  final User user;
  final List<Navigation> nav;
  final Navigation currentPage;

  AppState({
    @required this.user,
    @required this.nav,
    @required this.currentPage
  });

  factory AppState.initial() => AppState(
    user: null,
    nav : [Navigation.Day, Navigation.Search, Navigation.Profile],
    currentPage: Navigation.Day
  );
}

String getTitle(Navigation nav) {
  return nav.toString().split(".").last;
}