import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:stronk/presentation/stronk_home/stronk_home.dart';
import 'package:stronk/redux/state/app_state.dart';

class StronkHomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) => StoreConnector<AppState, StronkHomeVM>(
    converter: (Store<AppState> store) => StronkHomeVM.create(store),
    builder: (BuildContext context, StronkHomeVM stronkHomeVM)=> Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: stronkHomeVM.onNavItemPressed,
        currentIndex: stronkHomeVM.getCurrentPosition(),
        items: stronkHomeVM.pages.map((Navigation nav) => BottomNavigationBarItem(
          title: new Text(getTitle(nav)),
          icon : new Icon(getIcon(nav)),
        )).toList(),
      )
    ),
  );
}

IconData getIcon(Navigation nav) {
  switch (nav) {
    case Navigation.Day: return Icons.home;
    case Navigation.Search: return Icons.search;
    case Navigation.Profile: return Icons.person;
    default : return null;
  }
}