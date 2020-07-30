import 'package:mockito/mockito.dart';
import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/domain/model/record.dart';
import 'package:stronk/presentation/active_workout/active_workout_bloc.dart';
import 'package:test/test.dart';

void main() {
  ActiveWorkoutBloc activeWorkoutBloc;
  WorkoutRepository mockWorkoutRepo;

  setUp(() {
    mockWorkoutRepo = MockWorkoutRepo();
    activeWorkoutBloc = ActiveWorkoutBloc(workoutRepo: mockWorkoutRepo);
  });

  tearDown(() {
    activeWorkoutBloc.close();
  });

  test("complete exercise updates workout record", () async {
    var mockWorkout = WorkoutRepositoryImpl.mockWorkout();
    when(mockWorkoutRepo.mockRetrieveWorkout()).thenAnswer((_) => Future.value(mockWorkout));

    var matcher = TypeMatcher<ActiveWorkoutState>();
    var matchEndState = (_) {
      var failedWorkoutSet = activeWorkoutBloc.state.setRecords[0][0];
      expect(failedWorkoutSet.repsBeforeFailure, null);
    };

    expectLater(
        activeWorkoutBloc,
        emitsInOrder([
          matcher.having((state) => state.workoutRef, "initially no workout ref", null),
          matcher.having((state) => state.setRecords[0][0].status, "incomplete set record", Status.Incomplete),
          matcher.having((state) => state.setRecords[0][0].status, "passed set record", Status.Passed),
        ])).then((_) => matchEndState);

    activeWorkoutBloc.add(CompleteExerciseEvent());
  });

  test("fail exercise updates workout record", () {
    var mockWorkout = WorkoutRepositoryImpl.mockWorkout();
    when(mockWorkoutRepo.mockRetrieveWorkout()).thenAnswer((_) => Future.value(mockWorkout));

    var matcher = TypeMatcher<ActiveWorkoutState>();

    var matchEndState = (_) {
      var failedWorkoutSet = activeWorkoutBloc.state.setRecords[0][0];
      expect(failedWorkoutSet.repsBeforeFailure, 2);
    };

    expectLater(
        activeWorkoutBloc,
        emitsInOrder([
          matcher.having((state) => state.workoutRef, "initially no workout ref", null),
          matcher.having((state) => state.setRecords[0][0].status, "incomplete set record", Status.Incomplete),
          matcher.having((state) => state.setRecords[0][0].status, "failed set record", Status.Failed),
        ])).then((_) => matchEndState);

    activeWorkoutBloc.add(FailExerciseEvent(2));
  });

  test("completed workout count is not incremented until all sets of an exercise are complete", () {
    var mockWorkout = WorkoutRepositoryImpl.mockWorkout();
    when(mockWorkoutRepo.mockRetrieveWorkout()).thenAnswer((_) => Future.value(mockWorkout));

    var matcher = TypeMatcher<ActiveWorkoutState>();

    var matchEndState = (_) {
      var failedWorkoutSet = activeWorkoutBloc.state.setRecords[0][0];
      expect(failedWorkoutSet.repsBeforeFailure, 2);
    };

    expectLater(
        activeWorkoutBloc,
        emitsInOrder([
          matcher.having((state) => state.workoutRef, "initially no workout ref", null),
          matcher.having((state) => state.completedExerciseCount, "initial", 0),
          matcher
              .having((state) => state.completedExerciseCount, "0/3 sets completed", 0)
              .having((state) => state.remainingExerciseCount, "3/3 exercises remaining", 3),
    ])).then((_) => matchEndState);

    activeWorkoutBloc.add(CompleteExerciseEvent());
  });

  test("completed workout count is incremented when all sets are completed for an exercise", () {
    var mockWorkout = WorkoutRepositoryImpl.mockWorkout();
    when(mockWorkoutRepo.mockRetrieveWorkout()).thenAnswer((_) => Future.value(mockWorkout));

    var matcher = TypeMatcher<ActiveWorkoutState>();

    var matchEndState = (_) {
      var failedWorkoutSet = activeWorkoutBloc.state.setRecords[0][0];
      expect(failedWorkoutSet.repsBeforeFailure, 2);
    };

    expectLater(
        activeWorkoutBloc,
        emitsInOrder([
          matcher.having((state) => state.workoutRef, "initially no workout ref", null),
          matcher.having((state) => state.completedExerciseCount, "initial", 0),
          matcher.having((state) => state.completedExerciseCount, "1/3 sets completed", 0),
          matcher.having((state) => state.completedExerciseCount, "2/3 sets completed", 0),
          matcher
              .having((state) => state.completedExerciseCount, "3/3 sets completed", 1)
              .having((state) => state.remainingExerciseCount, "2/3 exercises remaining", 2),

        ])).then((_) => matchEndState);

    activeWorkoutBloc.add(CompleteExerciseEvent());
    activeWorkoutBloc.add(CompleteExerciseEvent());
    activeWorkoutBloc.add(CompleteExerciseEvent());
  });
}

class MockWorkoutRepo extends Mock implements WorkoutRepository {}
