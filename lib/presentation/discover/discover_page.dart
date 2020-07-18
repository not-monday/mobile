import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stronk/api/workout_repo.dart';

import 'discover_bloc.dart';

class DiscoverPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workoutRepo = RepositoryProvider.of<WorkoutRepository>(context);

    return BlocProvider(
      create: (context) => DiscoverBloc(workoutRepo: workoutRepo),
      child: BlocBuilder<DiscoverBloc, DiscoverState>(
        // separating the rendering of the page is much cleaner
        builder: buildPage),
    );
  }

  Widget buildPage(BuildContext context, DiscoverState workoutState) {
    return  Scaffold(
      body: Column(children: [
        Text("test"),
      ]),
    );
  }
}
