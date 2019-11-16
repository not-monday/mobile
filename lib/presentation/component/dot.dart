import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Dot extends StatelessWidget {
  final bool isActive;

  Dot({
    this.isActive = false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      width: 10,
      height: 10,
      decoration: new BoxDecoration(
        color: getColor(),
        shape: BoxShape.circle,
      ),
    );
  }

  Color getColor() {
    if (isActive) {
      return Colors.yellow[400];
    } else {
      return Colors.yellow[700];
    }
  }
}