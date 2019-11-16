import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GreetingCard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
          top: 40,
          left: 20,
          right: 20,
          bottom: 20
        ),
        alignment: Alignment.topLeft,
        child: Column(
          children: <Widget>[
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Hi Richard",
                  textScaleFactor: 2,
                  style: TextStyle(color: Colors.white),
                )
            ),
            Align(
                alignment: Alignment.centerLeft,
                child : Text(
                  "it's November 2, 2019",
                  textScaleFactor: 1.5,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                )
            ),
          ],
        )
    );
  }

}