import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stronk/api/graphql.dart';
import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/presentation/auth/auth_screen.dart';
import 'package:stronk/presentation/home/loading.dart';
import 'package:stronk/presentation/stronk_home/stronk_home_container.dart';
import 'package:stronk/redux/middleware/logging_middleware.dart';
import 'package:stronk/redux/middleware/navigation_middleware.dart';
import 'package:stronk/redux/middleware/request_middleware.dart';
import 'package:stronk/redux/reducer/app_reducer.dart';
import 'package:stronk/redux/state/app_state.dart';

import 'api/settings_repo.dart';
import 'api/user_repo.dart';
import 'auth_manager.dart';
import 'config.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() => runApp(MyApp());

// initialize google signin and firebase auth instances
final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

AuthManager authManager;
GraphQLUtility graphQLUtility;
WorkoutRepository workoutRepo;
UserRepository userRepo;
SettingsRepository settingsRepo;

class MyApp extends StatelessWidget {
  final Store<AppState> store = Store<AppState>(appReducer, initialState: AppState.initial(), middleware: [
    LoggingMiddleware(),
    RequestMiddleware(userRepo, workoutRepo),
    NavigationMiddleware(navigatorKey: navigatorKey),
  ]);

  // repositories that are made available for all descendants (lazily)
  final repositoryProviders = [
    RepositoryProvider<AuthManager>(create: (context) => authManager),
    RepositoryProvider<GraphQLUtility>(create: (context) => graphQLUtility),
    RepositoryProvider<UserRepository>(create: (context) => userRepo),
    RepositoryProvider<WorkoutRepository>(create: (context) => workoutRepo),
    RepositoryProvider<SettingsRepository>(create: (context) => settingsRepo),
  ];

  @override
  Widget build(BuildContext context) {
    // initialize the future outsize of the future builder
    var authManagerFuture = initializeAuthManager();

    return FutureBuilder<void>(
      future: authManagerFuture,
      builder: (BuildContext context, AsyncSnapshot<void> _) {
        return StoreProvider(
            store: store, child: MultiRepositoryProvider(providers: repositoryProviders, child: buildApp()));
      },
    );
  }

  Widget buildApp() {
    return StoreConnector<AppState, Widget>(
      converter: (store) {
        // map the screen state to actual screens
        switch (store.state.screenState) {
          case ScreenState.Ready:
            return StronkHomePage();
          case ScreenState.LoginRequired:
            return AuthScreen();
          default:
            return LoadingScreen();
        }
      },
      builder: (context, screen) => MaterialApp(
          title: 'Stronk',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: screen),
    );
  }

  /// We only need this async method because we need to wait for the sharedPrefs to resolve before creating the auth
  /// manager
  /// TODO consider converting auth manager init to static async
  Future<void> initializeAuthManager() async {
    await initializeConfig();
    authManager = AuthManager(
        googleSignIn: _googleSignIn,
        firebaseAuth: _auth,
        sharedPrefs: await SharedPreferences.getInstance(),
        store: store);

    graphQLUtility = GraphQLUtility();
    workoutRepo = WorkoutRepositoryImpl(utility: graphQLUtility);
    userRepo = UserRepositoryImpl(utility: graphQLUtility);
    settingsRepo = SettingsRepositoryImpl();
  }
}
