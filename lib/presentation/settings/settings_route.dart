import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stronk/api/settings_repo.dart';
import 'package:stronk/presentation/search/search_page.dart';
import 'package:stronk/presentation/settings/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) {
          final settingsRepository =
              RepositoryProvider.of<SettingsRepository>(context);
          return SettingsBloc(settingsRepository: settingsRepository);
        },
        child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, settingsState) => Scaffold(
                  body: Column(
                    children: <Widget>[
                      Center(
                        child: _renderOptions(
                          BlocProvider.of<SettingsBloc>(context),
                          settingsState,
                        ),
                      )
                    ],
                  ),
                )),
      );

  Widget _renderOptions(SettingsBloc bloc, SettingsState settingsState) {
    if (settingsState.options == null) {
      return Container(
          child: Text("Retrieving options"),
      );
    } else if(settingsState.options == []) {
      return Container(
        child: Text("No options"),
      );
    }

    final options = settingsState.options;
    final length = settingsState.options.length;


    return ListView.builder(
        itemCount: length,
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
