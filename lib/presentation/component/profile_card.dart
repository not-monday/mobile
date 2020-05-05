import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
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
            Text('Richard Wei')
          ],

        ));
  }
}
