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
    return DefaultTabController(
      length: 2,
      child: CustomScrollView(
        slivers: <Widget>[
          _buildHeader(context, state),
          SliverFillRemaining(
            child: TabBarView(
              children: <Widget>[
                _buildDescription(context, state),
                _buildReviews(context, state),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ProgramListingState state) {
    final programName = (state.program != null) ? state.program.name : program.name;
    final description = (state.program != null) ? state.program.description : program.description;

    return SliverAppBar(
      pinned: true,
      expandedHeight: 200.0,
      backgroundColor: Colors.red[300],
      title: Text(programName),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          child: Column(
            children: <Widget>[
              Text(programName),
              Text(description),
              Text("author")],
          ),
          margin: EdgeInsets.only(top: 100),
        ),
      ),
      bottom: TabBar(tabs: [
        Tab(icon: Text("Info")),
        Tab(icon: Text("Reviews")),
      ]),
    );
  }

  Widget _buildDescription(BuildContext context, ProgramListingState state) {
    return Container(child: Text("description"), height: 1000, color: Colors.black12);
  }

  Widget _buildReviews(BuildContext context, ProgramListingState state) {
    return Container(child: Text("description"), height: 1000, color: Colors.black12);
  }
}
