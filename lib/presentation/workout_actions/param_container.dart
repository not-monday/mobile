import 'package:dataclass/dataclass.dart';

@dataClass
class ParamContainer {
  final int newWeight;
  final int newRepCount;
  final int index;
  final String workoutId;
  final String workoutExerciseId;
  final String action;

  ParamContainer(
      {this.newWeight,
      this.newRepCount,
      this.workoutId,
      this.workoutExerciseId,
      this.action,
      this.index});
}
