import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stronk/presentation/search/search_page.dart';

class ProfileSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
            itemCount: 5,
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
                      MaterialPageRoute(builder: (context) => SearchPage())),
                  dense: true,
                  title: Text('choice',
                    style: TextStyle(
                      color: Colors.grey,
                    ),),
                ),
              );
            }
        );
  }

}