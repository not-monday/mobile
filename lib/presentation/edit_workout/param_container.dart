import 'package:dataclass/dataclass.dart';

@dataClass
class ParamContainer {
  final int newWeight;
  final int newRepCount;
  final String workoutId;
  final String workoutExerciseId;

  ParamContainer(
      {this.newWeight,
      this.newRepCount,
      this.workoutId,
      this.workoutExerciseId});
}
