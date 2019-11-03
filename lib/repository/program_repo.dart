import 'package:stronk/domain/model/program.dart';

class ProgramRepository {
  Future<Program> retrieveProgram() async {
    // todo replace with real program fetch call
    return Program(name: "Test program");
  }
}