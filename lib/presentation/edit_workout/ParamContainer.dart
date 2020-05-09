import 'package:dataclass/dataclass.dart';

@dataClass
class ParamContainer {
  final int _newWeight;
  final int _newRepCount;
  final String _workoutId;
  final String _workoutExerciseId;

  ParamContainer(this._newWeight, this._newRepCount, this._workoutId,
      this._workoutExerciseId);

  int get newWeight => _newWeight;

  int get newRepCount => _newRepCount;

  String get workoutId => _workoutId;

  String get workoutExerciseId => _workoutExerciseId;
}
