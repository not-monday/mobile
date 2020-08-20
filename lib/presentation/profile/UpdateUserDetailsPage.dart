
import 'package:stronk/domain/constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:stronk/presentation/profile/profile_bloc.dart';

class UpdateUserDetailsPage extends StatelessWidget {
  final ProfileBloc profileBloc;
  UpdateUserDetailsPage({@required this.profileBloc});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _renderAppBar(context, this.profileBloc),
      body: _renderBody(context, this.profileBloc),
    );
  }

  _renderAppBar(BuildContext context, ProfileBloc profileBloc){
    AppBar(
        title: Text(Constants.APP_NAME),
    centerTitle: true,
    titleSpacing: 0
    );
  }

  _renderBody(BuildContext context, ProfileBloc profileBloc) {
    return Container(
        child: Column (
          children: <Widget>[
            FlatButton(
                child: Text("Update email"),
                onPressed: () => {
                  profileBloc.add(new UpdateEmailInfoEvent(name: profileBloc.state.user.name, newEmail: "new" + profileBloc.state.user.email))
                }
            ),
            FlatButton(
              child: Text("Update name"),
              onPressed: () => {
                profileBloc.add(new UpdateNameEvent(newName: "new" + profileBloc.state.user.name, email: profileBloc.state.user.email))
              },
            )
          ],
        )
    );
  }
}