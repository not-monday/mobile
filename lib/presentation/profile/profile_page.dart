import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stronk/api/user_repo.dart';
import 'package:stronk/domain/constants.dart' as Constants;
import 'package:stronk/presentation/component/profile_card.dart';
import 'package:stronk/presentation/component/profile_settings.dart';
import 'package:stronk/presentation/settings/settings_route.dart';

import '../../auth_manager.dart';
import 'profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userRepository = RepositoryProvider.of<UserRepository>(context);
    final authManager = RepositoryProvider.of<AuthManager>(context);
    return BlocProvider(
      create: (context) =>
          ProfileBloc(userRepository: userRepository, authManager: authManager),
      child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) => Scaffold(
              resizeToAvoidBottomPadding: false,
              appBar: _renderAppBar(
                  context, BlocProvider.of<ProfileBloc>(context), profileState),
              body: _renderSettings(profileState))),
    );
  }

  _renderAppBar(BuildContext context, ProfileBloc profileBloc,
      ProfileState profileState) {
    return AppBar(
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
    );
  }
  // TODO look into using future builder to avoid exception when waiting for user data
  // Added an if statement to avoid null exception
  _renderSettings(ProfileState profileState) {
    if(profileState.user.name == "") {
      return Container(child : Text("Waiting for user"));
    }

    return Container(
        child: Column(
      children: <Widget>[
        ProfileCard(profileState: profileState),
        Expanded(
          child: SizedBox(child: ProfileSettings()),
        )
      ],
    ));
  }
}
