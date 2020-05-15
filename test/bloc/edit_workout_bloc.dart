import 'package:mockito/mockito.dart';
import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/domain/model/workout.dart';
import 'package:stronk/presentation/edit_workout/edit_workout_bloc.dart';
import 'package:stronk/presentation/edit_workout/param_container.dart';
import 'package:test/test.dart';
import 'package:stronk/domain/constants.dart' as Constants;

class MockWorkoutRepo extends Mock implements WorkoutRepository {}

void main() {
  EditWorkoutBloc mockEditWorkoutBloc;
  WorkoutRepository mockWorkoutRepo;

  setUp(() {
    mockWorkoutRepo = MockWorkoutRepo();
    mockEditWorkoutBloc = EditWorkoutBloc(workoutRepo: mockWorkoutRepo);
  });

  tearDown(() {
    mockEditWorkoutBloc.close();
  });

  test("Updated Program name", () async {
    var mockProgram = WorkoutRepositoryImpl.mockProgram();
    when(mockWorkoutRepo.retrieveProgram())
        .thenAnswer((_) => Future.value(mockProgram));

    var matcher = TypeMatcher<EditWorkoutState>();
    var matchEndState = (_) {
      var programName = mockEditWorkoutBloc.state.programRef.name;
      expect(programName, "new mock program");
    };

    expectLater(
        mockEditWorkoutBloc,
        emitsInOrder([
          matcher.having(
              (state) => state.programRef, "initially no program ref", null),
          matcher.having((state) => state.programRef.name,
              "update program name", "mock program name"),
        ])).then((_) => matchEndState);

    mockEditWorkoutBloc.add(EditProgramNameEvent("new mock program"));
  });

  test("edit workout name", () async {
    var mockProgram = WorkoutRepositoryImpl.mockProgram();
    when(mockWorkoutRepo.retrieveProgram())
        .thenAnswer((_) => Future.value(mockProgram));

    var matcher = TypeMatcher<EditWorkoutState>();

    var matchEndState = (_) {
      var programName = mockEditWorkoutBloc.state.workoutRef[0].name;
      expect(programName, "new workout name");
    };

    expectLater(
        mockEditWorkoutBloc,
        emitsInOrder([
          matcher.having(
              (state) => state.workoutRef, "Initial workoutRef is null", null),
          matcher.having((state) => state.workoutRef[0].name,
              "Initial workout name", "mock workout")
        ])).then((_) => matchEndState);

    mockEditWorkoutBloc.add(EditWorkoutEvent(
        workoutId: mockProgram.workouts[0].id,
        editAction: Constants.EDIT_WORKOUT_NAME,
        newValue: "new workout name"));
  });

  test("edit workout description", () async {
    var mockProgram = WorkoutRepositoryImpl.mockProgram();
    when(mockWorkoutRepo.retrieveProgram())
        .thenAnswer((_) => Future.value(mockProgram));

    var matcher = TypeMatcher<EditWorkoutState>();

    var matchEndState = (_) {
      var programName = mockEditWorkoutBloc.state.workoutRef[0].description;
      expect(programName, "new workout description");
    };

    expectLater(
        mockEditWorkoutBloc,
        emitsInOrder([
          matcher.having(
              (state) => state.workoutRef, "Initial workoutRef is null", null),
          matcher.having((state) => state.workoutRef[0].description,
              "Initial workout name", "mock description")
        ])).then((_) => matchEndState);

    mockEditWorkoutBloc.add(EditWorkoutEvent(
        workoutId: mockProgram.workouts[0].id,
        editAction: Constants.EDIT_WORKOUT_DESCRIPTION,
        newValue: "new workout program"));
  });

  test("edit workout set and rep", () async {
    var mockProgram = WorkoutRepositoryImpl.mockProgram();
    when(mockWorkoutRepo.retrieveProgram())
        .thenAnswer((_) => Future.value(mockProgram));

    var matcher = TypeMatcher<EditWorkoutState>();

    var matchEndState = (_) {
      var workoutExerciseSetAndRep = mockEditWorkoutBloc
          .state.workoutRef[0].workoutExercises[0].exerciseSets[0];
      expect(workoutExerciseSetAndRep, ExerciseSet(weight: 20, number: 10));
    };

    expectLater(
        mockEditWorkoutBloc,
        emitsInOrder([
          matcher.having(
              (state) => state.programRef, "Initial workoutRef is null", null),
          matcher.having(
              (state) =>
                  state.workoutRef[0].workoutExercises[0].exerciseSets[0],
              "initial weight",
              mockProgram.workouts[0].workoutExercises[0].exerciseSets[0]),
        ])).then((_) => matchEndState);

    mockEditWorkoutBloc.add(EditWorkoutExerciseSetsRepsEvent(
        new ParamContainer(
            workoutId: mockProgram.workouts[0].id,
            workoutExerciseId: mockProgram.workouts[0].workoutExercises[0].id,
            newRepCount: 10,
            newWeight: 20),
        0));
  });
}
