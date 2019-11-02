import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:stronk/redux/state/app_state.dart';

import 'profile_vm.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StoreConnector<AppState, ProfileVM> (
    converter: (Store<AppState> store) => ProfileVM.create(store),
    builder: (BuildContext context, ProfileVM homeVM) => Scaffold(
      appBar: AppBar(
        title: Text(homeVM.user.name),
      )
    ),
  );
}