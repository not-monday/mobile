import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stronk/presentation/profile/profile_bloc.dart';
import 'package:stronk/presentation/workout_actions/PopUpMenu.dart';

class ProfileCard extends StatelessWidget {
  final ProfileState profileState;
  final ProfileBloc profileBloc;

  ProfileCard({@required this.profileState, this.profileBloc});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 30),
        alignment: Alignment.topCenter,
        child:Card(
          child:  Column(
            children: <Widget>[
              ListTile(trailing: buildPopUpMenu(context)),
              Icon(
                Icons.account_circle,
                size: 100.0,
              ),
              Text(profileState.user.name),
              Text(profileState.user.email)
            ],
          ),
        )
    );
  }

  Widget buildPopUpMenu(BuildContext context) {
    return PopUpMenu.createPopup([
      new PopUpMenu(option: "Edit email",
          onTap: () => {
            profileBloc.add(new UpdateEmailInfoEvent(name: profileState.user.name, newEmail: "new" + profileState.user.email))
          }),
      new PopUpMenu(option: "Edit name",
        onTap: () => {
          profileBloc.add(new UpdateNameEvent(newName: "new" + profileState.user.name, email: profileState.user.email))
        }
      )
    ]);
  }
}
