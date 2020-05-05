import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stronk/api/graphql.dart';
import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/presentation/active_workout/active_workout_route.dart';
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

  // repositories that are made available for all descendants
  final repositoryProviders = [
    RepositoryProvider<WorkoutRepository>(create : (context) => workoutRepo),
    RepositoryProvider<SettingsRepository>(create : (context) => settingsRepo)
  ];

  @override
  Widget build(BuildContext context) {
    // initialize the future outsize of the future builder
    var authManagerFuture = initializeAuthManager();

    // initialize action to retrieve the user and their current program
//    store.dispatch(RetrieveUserAction());
//    store.dispatch(RetrieveProgramAction());

    return FutureBuilder<AuthManager>(
      future: authManagerFuture,
      builder: (BuildContext context, AsyncSnapshot<AuthManager> snapshot) {
        authManager = snapshot.data;
        if (authManager == null) return Container();

        handleSignIn(context);
        return StreamBuilder <Account>(
          stream: authManager?.currentAccount,
          builder: (BuildContext context, AsyncSnapshot<Account> snapshot) {
            return StoreProvider(
              store: store,
              child: MultiRepositoryProvider(providers: repositoryProviders, child: _buildAppUI())
            );
          }
        );
      },
    );
  }

  /// We only need this async method because we need to wait for the sharedPrefs to resolve before creating the auth
  /// manager
  /// TODO consider converting auth manager init to static async
  Future<AuthManager> initializeAuthManager() async {
    initializeConfig();
    authManager = AuthManager(
      googleSignIn: _googleSignIn, firebaseAuth: _auth, sharedPrefs: await SharedPreferences.getInstance());

    graphQLUtility = GraphQLUtility(authManager: authManager);
    workoutRepo = WorkoutRepositoryImpl(utility: graphQLUtility);
    userRepo = UserRepositoryImpl(utility: graphQLUtility);
    settingsRepo = SettingsRepositoryImpl();

    return authManager;
  }

  /// handles authentication for the user
  /// - we need to separate this out into its own async function because the shared preferences needed to construct
  /// the auth manager is obtained async as well
  Future handleSignIn(BuildContext context) async {
    authManager.handleSignIn().catchError((e) {
      Fluttertoast.showToast(
        msg: "error signing in $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    });
  }

  // renders the actual app UI
  Widget _buildAppUI() {
    var app = MaterialApp(
      title: 'Stronk',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        '/': (context) => StronkHomePage(),
        '/loading': (context) => LoadingScreen(),
        '/workout': (context) => ActiveWorkoutRoute(),
      });
    return app;
  }
}
