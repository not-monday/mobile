import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stronk/api/graphql.dart';
import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/presentation/program_listing/program_listing_bloc.dart';

class ProgramListingPage extends StatelessWidget {
  final Program program;

  ProgramListingPage({@required this.program});

  @override
  Widget build(BuildContext context) {
    final workoutRepo = RepositoryProvider.of<WorkoutRepository>(context);
    final graphqlUtil = RepositoryProvider.of<GraphQLUtility>(context);

    return BlocProvider(
      create: (context) =>
          ProgramListingBloc(workoutRepo: workoutRepo, graphqlUtil: graphqlUtil, programId: int.parse(program.id)),
      child: BlocBuilder<ProgramListingBloc, ProgramListingState>(builder: _buildPage),
    );
  }

  Widget _buildPage(BuildContext context, ProgramListingState state) {
    return Scaffold(
        body: Column(
      children: [_buildHeader(context, state)],
    ));
  }

  Widget _buildHeader(BuildContext context, ProgramListingState state) {
    final text = (state.program != null) ? state.program.name : program.name;
    return Text(text);
  }
}
