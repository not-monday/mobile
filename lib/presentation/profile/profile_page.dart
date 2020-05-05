import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:stronk/redux/state/app_state.dart';
import 'package:stronk/presentation/settings/settings_route.dart';
import 'package:stronk/presentation/component/profile_card.dart';
import 'package:stronk/presentation/component/profile_settings.dart';
import 'package:stronk/domain/constants.dart' as Constants;

import 'profile_vm.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StoreConnector<AppState, ProfileVM>(
        converter: (Store<AppState> store) => ProfileVM.create(store),
        builder: (BuildContext context, ProfileVM profileVM) => Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text(Constants.APP_NAME),
            centerTitle: true,
            titleSpacing: 0,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsPage()));
                },
              ),
            ],
          ),
          body: Container(
            child: Column(
             children: <Widget>[
               ProfileCard(),
               Expanded(
                 child: SizedBox(
                     child: ProfileSettings()
                 ),
               )
             ],
            ),
          )
        ),
      );
}
