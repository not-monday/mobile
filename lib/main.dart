import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stronk/api/graphql.dart';
import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/presentation/active_workout/active_workout_route.dart';
import 'package:stronk/presentation/stronk_home/stronk_home_container.dart';
import 'package:stronk/redux/middleware/logging_middleware.dart';
import 'package:stronk/redux/middleware/navigation_middleware.dart';
import 'package:stronk/redux/middleware/request_middleware.dart';
import 'package:stronk/redux/reducer/app_reducer.dart';
import 'package:stronk/redux/state/app_state.dart';

import 'api/settings_repo.dart';
import 'api/user_repo.dart';
import 'auth_manager.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() => runApp(MyApp());

// initialize google signin and firebase auth instances
final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

AuthManager authManager;
GraphQLUtility utility;
WorkoutRepository workoutRepo;
UserRepository userRepo;

class MyApp extends StatelessWidget {
  final Store<AppState> store = Store<AppState>(
    appReducer,
    initialState :AppState.initial(),
    middleware: [
      LoggingMiddleware(),
      RequestMiddleware(userRepo, workoutRepo),
      NavigationMiddleware(navigatorKey : navigatorKey),
    ]
  );

  // repositories that are made available for all descendants
  final repositoryProviders = [
    RepositoryProvider<WorkoutRepository>(create : (context) => workoutRepo),
    RepositoryProvider<SettingsRepository>(create : (context) => SettingsRepositoryImpl())
  ];

  @override
  Widget build(BuildContext context) {
    // initialize action to retrieve the user and their current program
//    store.dispatch(RetrieveUserAction());
//    store.dispatch(RetrieveProgramAction());

      var authManagerFuture = getAuthManager();

      return FutureBuilder<AuthManager>(
        future: authManagerFuture,
        builder: (BuildContext context, AsyncSnapshot<AuthManager> snapshot) {
          var authManager = snapshot.data;
          if (authManager == null) {
            // TODO add loading animation/screen
            return MaterialApp(
              builder: (BuildContext context, Widget widget) => Text("Loading"),
            );
          }

          initializeAuth(context);
          return StreamBuilder<FirebaseUser>(
            stream: authManager.currentUser,
            builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
              var currentUser = snapshot.data;
              if (currentUser == null) {
                // TODO add loading animation/screen
                return MaterialApp(
                  builder: (BuildContext context, Widget widget) => Text("Loading"),
                );
              }

              return StoreProvider(
                  store: store,
                  child: MultiRepositoryProvider(
                      providers: repositoryProviders,
                      child: _buildAppUI()
                  )
              );
            },
          );
        },
      );
    }

    // TODO convert to factory or static method
    Future<AuthManager> getAuthManager() async {
      authManager = AuthManager(googleSignIn: _googleSignIn, firebaseAuth:  _auth, sharedPrefs: await SharedPreferences.getInstance());
      return authManager;
    }

    /// handles authentication for the user
    /// - we need to separate this out into its own async function because the shared preferences needed to construct
    /// the auth manager is obtained async as well
    Future initializeAuth(BuildContext context) async {
      authManager.handleSignIn()
          .then((_) {
            utility = GraphQLUtility(authManager: authManager);
            workoutRepo = WorkoutRepositoryImpl(utility: utility);
            userRepo = UserRepositoryImpl(utility: utility);
          })
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