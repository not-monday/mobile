import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stronk/api/graphql.dart';
import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/domain/model/workout.dart';

import 'discover_bloc.dart';

class DiscoverPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workoutRepo = RepositoryProvider.of<WorkoutRepository>(context);
    final graphqlUtil = RepositoryProvider.of<GraphQLUtility>(context);

    return BlocProvider(
      create: (context) => DiscoverBloc(workoutRepo: workoutRepo, graphqlUtil: graphqlUtil),
      child: BlocBuilder<DiscoverBloc, DiscoverState>(
        // separating the rendering of the page is much cleaner
        builder: buildPage),
    );
  }

  Widget buildPage(BuildContext context, DiscoverState workoutState) {
    return Scaffold(
      body: Column(
        children: workoutState.programs.map((program) => _renderProgramPreview(program)).toList()
      ),
    );
  }

  Widget _renderProgramPreview(Program program) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: 2
      ),
      child: Card(
        child : Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10
          ),
          child: ListTile(
            title: Text(
              program.name,
              style: TextStyle(fontWeight: FontWeight.bold),
              textScaleFactor: 1.5,
            ),
            subtitle: Text(
              program.description,
              textScaleFactor: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
