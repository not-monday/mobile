import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stronk/api/user_repo.dart';
import 'package:stronk/presentation/settings/settings_route.dart';
import 'package:stronk/presentation/component/profile_card.dart';
import 'package:stronk/presentation/component/profile_settings.dart';
import 'package:stronk/domain/constants.dart' as Constants;

import 'profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) {
          final userRepository = RepositoryProvider.of<UserRepository>(context);
          return ProfileBloc(userRepository: userRepository);
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, profileState) => Scaffold(
                resizeToAvoidBottomPadding: false,
                appBar: _renderAppBar(context,
                    BlocProvider.of<ProfileBloc>(context), profileState),
                body: _renderSettings(profileState))),
      );

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

  _renderSettings(ProfileState profileState) {
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
