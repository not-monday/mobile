import 'package:mockito/mockito.dart';
import 'package:stronk/api/workout_repo.dart';
import 'package:stronk/domain/model/record.dart';
import 'package:stronk/main.dart';
import 'package:stronk/presentation/active_workout/active_workout_bloc.dart';
import 'package:test/test.dart';

void main() {
  test("complete exercise updates workout record", () async {
    var mockWorkout = WorkoutRepositoryImpl.mockWorkout();
    var mockWorkoutRepo = MockWorkoutRepo();
    when(mockWorkoutRepo.retrieveWorkout())
        .thenAnswer((_) => Future.value(mockWorkout));

    var activeWorkoutBloc = ActiveWorkoutBloc(workoutRepo: workoutRepo);


    var matchers = [
      stateMatcher.having((state) => state.workoutRef == null, "init", true),
      stateMatcher.having((state) => state.workoutRef == null, "init", false),
//      stateMatcher.having((state) => state.setRecords[0].length, "start", 0)
    ];

//    expectLater(activeWorkoutBloc, emitsInOrder(matchers));
//    await expectLater(activeWorkoutBloc, emits(
//        stateMatcher.having((state) => state.workoutRef, "start", null)
//    ));
//    await expectLater(activeWorkoutBloc, emits(
//        stateMatcher.having((state) => state.workoutRef, "start", mockWorkout)
//    ));
    expectLater(activeWorkoutBloc, emitsInOrder(matchers));
    activeWorkoutBloc.add(InitEvent());
//    expectLater(
//      activeWorkoutBloc,
//      emitsInOrder([stateMatcher.having((state) => state.setRecords, "start", mockWorkout)]),
//    );

//    activeWorkoutBloc
//
//    expectLater(
//        activeWorkoutBloc,
//        emitsThrough(stateMatcher.having(
//            (state) => state.workoutRef != null, "start", true)
//        ));
//    .then((onValue) => )

//    expectLater(
//        activeWorkoutBloc,
//        emitsInOrder([
////        stateMatcher.having((state) => state.setRecords != null, "start", false),
//          stateMatcher.having((state) => state.workoutRef != null, "start", true),
//        ])
//    );

//    activeWorkoutBloc.add(CompleteExerciseEvent());
  });

  test("fail exercise updates workout record", () {
    var mockWorkout = WorkoutRepositoryImpl.mockWorkout();
    var mockWorkoutRepo = MockWorkoutRepo();
    when(mockWorkoutRepo.retrieveWorkout())
        .thenAnswer((_) => Future.value(mockWorkout));

    var activeWorkoutBloc = ActiveWorkoutBloc(workoutRepo: workoutRepo);

    var repsBeforeFailure = 2;
    activeWorkoutBloc.add(FailExerciseEvent(repsBeforeFailure));

    expect(activeWorkoutBloc.state.setRecords[0].length, 1);
    var failedExerciseRecord = activeWorkoutBloc.state.setRecords[0][0].status;
    expect(failedExerciseRecord, Status.Failed);
    expect(failedExerciseRecord, repsBeforeFailure);
  });
}

const stateMatcher = TypeMatcher<ActiveWorkoutState>();

class MockWorkoutRepo extends Mock implements WorkoutRepository {}
