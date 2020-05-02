import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/presentation/active_workout/active_workout_route.dart';
import 'package:stronk/presentation/stronk_home/stronk_home_container.dart';
import 'package:stronk/redux/middleware/logging_middleware.dart';
import 'package:stronk/redux/middleware/navigation_middleware.dart';
import 'package:stronk/redux/middleware/request_middleware.dart';
import 'package:stronk/redux/reducer/app_reducer.dart';
import 'package:stronk/redux/state/app_state.dart';

import 'api/user_repo.dart';
import 'auth_manager.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() => runApp(MyApp());

// initialize google signin and firebase auth instances
final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

final WorkoutRepository workoutRepo = WorkoutRepositoryImpl();

SharedPreferences prefs;
AuthManager authManager;


class MyApp extends StatelessWidget {
  final Store<AppState> store = Store<AppState>(
    appReducer,
    initialState :AppState.initial(),
    middleware: [
      LoggingMiddleware(),
      RequestMiddleware(UserRepo(), WorkoutRepositoryImpl()),
      NavigationMiddleware(navigatorKey : navigatorKey),
    ]
  );

  // repositories that are made available for all descendants
  final repositoryProviders = [
    RepositoryProvider<WorkoutRepository>(create : (context) => WorkoutRepositoryImpl())
  ];

  @override
  Widget build(BuildContext context) {
    // initialize action to retrieve the user and their current program
    store.dispatch(RetrieveUserAction());
    store.dispatch(RetrieveProgramAction());

    return FutureBuilder(
      future: handleAuth(context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return StoreProvider(
            store: store,
            child: MultiRepositoryProvider(
              providers: repositoryProviders,
              child: _buildAppUI()
            )
        );
      },
    );
  }

  /// handles authentication for the user
  /// - we need to separate this out into its own async function because the shared preferences needed to construct
  /// the auth manager is obtained async as well
  Future handleAuth(BuildContext context) async{
    AuthManager(googleSignIn: _googleSignIn, firebaseAuth:  _auth, sharedPrefs: await SharedPreferences.getInstance())
        .handleSignIn()
        .catchError((e) {
      final scaffold = Scaffold.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text("error signing in $e"),
          action: SnackBarAction(
              label: 'try again', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    });
  }

  // renders the actual app UI
  Widget _buildAppUI() {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => StronkHomePage(),
        '/workout': (context) => ActiveWorkoutRoute(),
      }
    );
  }
}