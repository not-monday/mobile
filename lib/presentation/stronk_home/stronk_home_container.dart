import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:stronk/presentation/home/home_route.dart';
import 'package:stronk/presentation/profile/profile_page.dart';
import 'package:stronk/presentation/search/search_page.dart';
import 'package:stronk/presentation/stronk_home/stronk_home_vm.dart';
import 'package:stronk/redux/state/app_state.dart';

class StronkHomePage extends StatefulWidget {
  StronkHomePage();

  @override
  State<StatefulWidget> createState() => _StronkHomePage();
}

class _StronkHomePage extends State<StronkHomePage> {
  int _selectedIndex = 0;
  List<Widget> navPages = [HomeRoute(), SearchPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, StronkHomeVM>(
    converter: (Store<AppState> store) => StronkHomeVM.create(store),
    builder: _buildUI
  );

  Widget _buildUI(BuildContext context, StronkHomeVM stronkHomeVM) {
    return Scaffold(
      body: Center(
        child : navPages[_selectedIndex]
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectNavigation,
        currentIndex: _selectedIndex,
        items: stronkHomeVM.pages.map((Navigation nav) => BottomNavigationBarItem(
          title: new Text(getTitle(nav)),
          icon : new Icon(getIcon(nav)),
        )).toList(),
      )
    );
  }

  _selectNavigation(int selected) {
    setState(() {
      _selectedIndex = selected;
    });
  }
}

IconData getIcon(Navigation nav) {
  switch (nav) {
    case Navigation.Day: return Icons.home;
    case Navigation.Search: return Icons.search;
    case Navigation.Profile: return Icons.person;
    default : return null;
  }
}