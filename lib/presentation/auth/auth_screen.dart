import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stronk/api/graphql.dart';
import 'package:stronk/auth_manager.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authManager = RepositoryProvider.of<AuthManager>(context);
    final graphQLUtil = RepositoryProvider.of<GraphQLUtility>(context);

    return Scaffold(
        body: Column(
      children: <Widget>[
        Text("Welcome to stronk!"),
        MaterialButton(
          child: Text("Login"),
          onPressed: () => _beginSignIn(
            authManager,
            graphQLUtil,
            context,
          ),
        )
      ],
    ));
  }

  /// begins the interactive sign on process
  _beginSignIn(AuthManager authManager, GraphQLUtility graphQLUtility, BuildContext context) {
    authManager.initialSignIn(graphQLUtility).catchError((e) {
      Fluttertoast.showToast(
        msg: "There was an error signing in",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    });
  }
}
