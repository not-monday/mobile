import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stronk/presentation/discover/discover_page.dart';
import 'package:stronk/presentation/profile/UpdateUserDetailsPage.dart';
import 'package:stronk/presentation/profile/profile_bloc.dart';

class ProfileSettings extends StatelessWidget {
  final List<String> options = [
    "Edit User Details"
  ];

  final ProfileBloc profileBloc;
  ProfileSettings({@required this.profileBloc});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
            itemCount: options.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 5, right: 5, top: 30, bottom: 0),
                width: double.infinity,
                height: 80.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blue)
                ),
                child: ListTile(
                  onTap: () =>  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UpdateUserDetailsPage(profileBloc: this.profileBloc))),
                  dense: true,
                  title: Text(options[index],
                    style: TextStyle(
                      color: Colors.grey,
                    ),),
                ),
              );
            }
        );
  }

}