import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stronk/presentation/profile/profile_bloc.dart';

class ProfileCard extends StatelessWidget {
  final ProfileState profileState;

  ProfileCard({@required this.profileState});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 30),
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 100.0,
            ),
            Text(profileState.user.name),
            Text(profileState.user.email)
          ],
        ));
  }
}
