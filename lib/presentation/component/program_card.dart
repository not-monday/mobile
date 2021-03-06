import 'package:flutter/material.dart';
import 'package:stronk/domain/model/workout.dart';

class ProgramCard extends StatelessWidget {

  final Program program;

  ProgramCard(this.program);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.album),
              title: Text(program.name),
              subtitle: Text("Week 1 out of 5"),
            ),
            ButtonBarTheme( // make buttons use the appropriate styles for cards
              data: null,
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('VIEW PROGRAM'),
                    onPressed: () { /* ... */ },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}