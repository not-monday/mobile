import 'package:mockito/mockito.dart';
import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/domain/constants.dart' as Constants;
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/presentation/workout_actions/param_container.dart';
import 'package:stronk/presentation/workout_actions/workout_action_bloc.dart';
import 'package:test/test.dart';

class MockWorkoutRepo extends Mock implements WorkoutRepository {}

void main() {
  WorkoutActionBloc mockWorkoutActionBloc;
  WorkoutRepository mockWorkoutRepo;

  setUp(() {
    mockWorkoutRepo = MockWorkoutRepo();
    mockWorkoutActionBloc = WorkoutActionBloc(workoutRepo: mockWorkoutRepo);
  });

  tearDown(() {
    mockWorkoutActionBloc.close();
  });

  test("Updated Program name", () async {
    var mockProgram = WorkoutRepositoryImpl.mockProgram();
    when(mockWorkoutRepo.retrieveProgram())
        .thenAnswer((_) => Future.value(mockProgram));

    var matcher = TypeMatcher<WorkoutActionState>();
    var matchEndState = (_) {
      var programName = mockWorkoutActionBloc.state.programRef.name;
      expect(programName, "new mock program");
    };

    expectLater(
        mockWorkoutActionBloc,
        emitsInOrder([
          matcher.having(
              (state) => state.programRef, "initially no program ref", null),
          matcher.having((state) => state.programRef.name,
              "update program name", "mock program name"),
        ])).then((_) => matchEndState);

    mockWorkoutActionBloc.add(EditProgramNameEvent("new mock program"));
  });

  test("edit workout name", () async {
    var mockProgram = WorkoutRepositoryImpl.mockProgram();
    when(mockWorkoutRepo.retrieveProgram())
        .thenAnswer((_) => Future.value(mockProgram));

    var matcher = TypeMatcher<WorkoutActionState>();

    var matchEndState = (_) {
      var programName = mockWorkoutActionBloc.state.workoutRef[0].name;
      expect(programName, "new workout name");
    };

    expectLater(
        mockWorkoutActionBloc,
        emitsInOrder([
          matcher.having(
              (state) => state.workoutRef, "Initial workoutRef is null", null),
          matcher.having((state) => state.workoutRef[0].name,
              "Initial workout name", "mock workout")
        ])).then((_) => matchEndState);

    mockWorkoutActionBloc.add(EditWorkoutEvent(
        workoutId: mockProgram.workouts[0].id,
        editAction: Constants.EDIT_WORKOUT_NAME,
        newValue: "new workout name"));
  });

  test("edit workout description", () async {
    var mockProgram = WorkoutRepositoryImpl.mockProgram();
    when(mockWorkoutRepo.retrieveProgram())
        .thenAnswer((_) => Future.value(mockProgram));

    var matcher = TypeMatcher<WorkoutActionState>();

    var matchEndState = (_) {
      var programName = mockWorkoutActionBloc.state.workoutRef[0].description;
      expect(programName, "new workout description");
    };

    expectLater(
        mockWorkoutActionBloc,
        emitsInOrder([
          matcher.having(
              (state) => state.workoutRef, "Initial workoutRef is null", null),
          matcher.having((state) => state.workoutRef[0].description,
              "Initial workout name", "mock description")
        ])).then((_) => matchEndState);

    mockWorkoutActionBloc.add(EditWorkoutEvent(
        workoutId: mockProgram.workouts[0].id,
        editAction: Constants.EDIT_WORKOUT_DESCRIPTION,
        newValue: "new workout program"));
  });

  test("edit workout set and rep", () async {
    var mockProgram = WorkoutRepositoryImpl.mockProgram();
    when(mockWorkoutRepo.retrieveProgram())
        .thenAnswer((_) => Future.value(mockProgram));

    var matcher = TypeMatcher<WorkoutActionState>();

    var matchEndState = (_) {
      var workoutExerciseSetAndRep = mockWorkoutActionBloc
          .state.workoutRef[0].workoutExercises[0].exerciseSets[0];
      expect(workoutExerciseSetAndRep, ExerciseSet(weight: 20, number: 10));
    };

    expectLater(
        mockWorkoutActionBloc,
        emitsInOrder([
          matcher.having(
              (state) => state.programRef, "Initial workoutRef is null", null),
          matcher.having(
              (state) =>
                  state.workoutRef[0].workoutExercises[0].exerciseSets[0],
              "initial weight",
              mockProgram.workouts[0].workoutExercises[0].exerciseSets[0]),
        ])).then((_) => matchEndState);

    mockWorkoutActionBloc.add(new SetsAndRepsEvent(
        params: new ParamContainer(
            workoutId: mockProgram.workouts[0].id,
            workoutExerciseId: mockProgram.workouts[0].workoutExercises[0].id,
            newRepCount: 10,
            newWeight: 20,
            action: Constants.EDIT_ACTION)));
  });

  test("add workout", () async {
    var mockProgram = WorkoutRepositoryImpl.mockProgram();
    when(mockWorkoutRepo.retrieveProgram())
        .thenAnswer((_) => Future.value(mockProgram));

    var matcher = TypeMatcher<WorkoutActionState>();

    var matchEndState = (_) {
      var workout = mockWorkoutActionBloc.state.workoutRef;
      var modifiedWorkout = workout;
      modifiedWorkout.add(new Workout(id: "1000"));
      expect(workout, modifiedWorkout);
    };

    expectLater(
        mockWorkoutActionBloc,
        emitsInOrder([
          matcher.having(
              (state) => state.programRef, "Initial workoutRef is null", null),
          matcher.having((state) => state.workoutRef, "initial workout list",
              mockProgram.workouts),
        ])).then((_) => matchEndState);

    mockWorkoutActionBloc
        .add(new WorkoutEvent(workoutId: "1000", action: Constants.ADD_ACTION));
  });

  test("delete workout", () async {
    var mockProgram = WorkoutRepositoryImpl.mockProgram();
    when(mockWorkoutRepo.retrieveProgram())
        .thenAnswer((_) => Future.value(mockProgram));

    var matcher = TypeMatcher<WorkoutActionState>();

    var matchEndState = (_) {
      var workout = mockWorkoutActionBloc.state.workoutRef;
      var modifiedWorkout = workout.sublist(0, workout.length - 2);
      expect(workout, modifiedWorkout);
    };

    expectLater(
        mockWorkoutActionBloc,
        emitsInOrder([
          matcher.having(
              (state) => state.programRef, "Initial workoutRef is null", null),
          matcher.having((state) => state.workoutRef, "initial workout list",
              mockProgram.workouts),
        ])).then((_) => matchEndState);

    mockWorkoutActionBloc.add(new WorkoutEvent(
        workoutId: mockProgram.workouts.last.id, action: Constants.ADD_ACTION));
  });

  test("add workout sets and reps", () async {
    var mockProgram = WorkoutRepositoryImpl.mockProgram();
    when(mockWorkoutRepo.retrieveProgram())
        .thenAnswer((_) => Future.value(mockProgram));

    var matcher = TypeMatcher<WorkoutActionState>();

    var matchEndState = (_) {
      var workoutExerciseSetAndRep = mockWorkoutActionBloc
              .state.workoutRef[0].workoutExercises[0].exerciseSets[
          mockWorkoutActionBloc.state.workoutRef[0].workoutExercises.length -
              1];
      expect(workoutExerciseSetAndRep, ExerciseSet(weight: 20, number: 10));
    };

    expectLater(
        mockWorkoutActionBloc,
        emitsInOrder([
          matcher.having(
              (state) => state.programRef, "Initial workoutRef is null", null),
          matcher.having(
              (state) =>
                  state.workoutRef[0].workoutExercises[0].exerciseSets.last,
              "last set and rep",
              mockProgram.workouts[0].workoutExercises[0].exerciseSets.last),
        ])).then((_) => matchEndState);

    mockWorkoutActionBloc.add(new SetsAndRepsEvent(
        params: new ParamContainer(
            workoutId: mockProgram.workouts[0].id,
            workoutExerciseId: mockProgram.workouts[0].workoutExercises[0].id,
            newRepCount: 10,
            newWeight: 20,
            action: Constants.ADD_ACTION)));
  });

  test("delete workout sets and reps", () async {
    var mockProgram = WorkoutRepositoryImpl.mockProgram();
    when(mockWorkoutRepo.retrieveProgram())
        .thenAnswer((_) => Future.value(mockProgram));

    var matcher = TypeMatcher<WorkoutActionState>();

    var matchEndState = (_) {
      var workoutExerciseSetAndRep = mockWorkoutActionBloc
          .state.workoutRef[0].workoutExercises[0].exerciseSets.last;
      var newFirstWorkoutExerciseSetAndRep = mockWorkoutActionBloc
          .state.workoutRef[0].workoutExercises[0].exerciseSets[1];
      expect(workoutExerciseSetAndRep, newFirstWorkoutExerciseSetAndRep);
    };

    expectLater(
        mockWorkoutActionBloc,
        emitsInOrder([
          matcher.having(
              (state) => state.programRef, "Initial workoutRef is null", null),
          matcher.having(
              (state) =>
                  state.workoutRef[0].workoutExercises[0].exerciseSets[0],
              "first set and rep",
              mockProgram.workouts[0].workoutExercises[0].exerciseSets[0]),
        ])).then((_) => matchEndState);

    mockWorkoutActionBloc.add(new SetsAndRepsEvent(
        params: new ParamContainer(
            workoutId: mockProgram.workouts[0].id,
            workoutExerciseId: mockProgram.workouts[0].workoutExercises[0].id,
            index: 0,
            action: Constants.DELETE_ACTION)));
  });
}
