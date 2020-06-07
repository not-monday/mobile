import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PopUpMenu {
  PopUpMenu({@required this.option, @required this.onTap});

  final String option;
  final VoidCallback onTap;

  static PopupMenuButton<String> createPopup(List<PopUpMenu> popupItems) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        popupItems.firstWhere((e) => e.option == value).onTap();
      },
      itemBuilder: (context) => popupItems
          .map((item) => PopupMenuItem<String>(
                value: item.option,
                child: Text(
                  item.option,
                ),
              ))
          .toList(),
    );
  }
}
