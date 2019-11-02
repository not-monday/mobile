import 'package:stronk/domain/model/program.dart';

class ProgramRepository {
  Future<Program> retrieveProgram() {
    // todo replace with real program fetch call
    return Future.value(Program(name: "Test program"));
  }
}