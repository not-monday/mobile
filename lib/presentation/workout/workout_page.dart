import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:stronk/presentation/stronk_home/stronk_home_vm.dart';
import 'package:stronk/redux/state/app_state.dart';

class WorkoutPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) => StoreConnector<AppState, StronkHomeVM>(
    converter: (Store<AppState> store) => StronkHomeVM.create(store),
    builder: (BuildContext context, StronkHomeVM stronkHomeVM)=> Scaffold(
      
    ),
  );
}
