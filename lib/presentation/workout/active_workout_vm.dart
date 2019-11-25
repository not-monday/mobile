
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/repository/program_repo.dart';

enum ActiveWorkoutEvent {
  Init, CompleteWorkoutExercise, FailedWorkoutExercise
}

class ActiveWorkoutState {
  bool loading;
  WorkoutExercise currentExercise;

  List<WorkoutExercise> remainingExercises;
  List<WorkoutExercise> completedExercises;

  ActiveWorkoutState({
    this.loading = false,
    this.currentExercise,
    @required this.remainingExercises,
    @required this.completedExercises,
  });
}

class ActiveWorkoutVM extends Bloc<ActiveWorkoutEvent, ActiveWorkoutState>{
  final ProgramRepository programRepo;

  ActiveWorkoutVM({
    @required this.programRepo
  }) {
    add(ActiveWorkoutEvent.Init);
  }

  @override
  ActiveWorkoutState get initialState => ActiveWorkoutState(
      loading: true,
      remainingExercises: List(),
      completedExercises: List(),
  );

  @override
  Stream<ActiveWorkoutState> mapEventToState(ActiveWorkoutEvent event) async* {
    switch(event) {
      case ActiveWorkoutEvent.Init:
        yield await _handleInitialize();
        break;
      case ActiveWorkoutEvent.CompleteWorkoutExercise:
        yield await _handleCompleteWorkoutExercise(true);
        break;
      case ActiveWorkoutEvent.FailedWorkoutExercise:
        yield await _handleCompleteWorkoutExercise(false);
        break;
    }
  }

  Future<ActiveWorkoutState> _handleInitialize() async{
    final workout = await programRepo.retrieveWorkout();
    final exercises = workout.workoutExercises;
    
    return ActiveWorkoutState(
      currentExercise: exercises.removeAt(0),
      remainingExercises: exercises,
      completedExercises: List(),
    );
  }

  Future<ActiveWorkoutState> _handleCompleteWorkoutExercise(bool success) async{
    state.completedExercises.add(state.currentExercise);

    final currentExercise = (state.remainingExercises.length > 0) ? state.remainingExercises.removeAt(0) : null;

    return ActiveWorkoutState(
      currentExercise: currentExercise,
      completedExercises: state.completedExercises,
      remainingExercises: state.remainingExercises,
    );
  }

}