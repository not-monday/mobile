import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:stronk/redux/state/app_state.dart';

import 'search_vm.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StoreConnector<AppState, SearchVM> (
    converter: (Store<AppState> store) => SearchVM.create(store),
    builder: (BuildContext context, SearchVM homeVM) => Scaffold(
      appBar: AppBar(
        title: Text(homeVM.user.name),
      )
    ),
  );
}