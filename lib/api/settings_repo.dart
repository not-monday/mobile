import 'package:stronk/domain/model/settings.dart';

abstract class SettingsRepository {
  Future<Settings> retrieveSettings();
}

class SettingsRepositoryImpl implements SettingsRepository {
  @override
  Future<Settings> retrieveSettings() async {
    return _mockSettings();
  }

  static List<String> _mockOptions() {
    return ["Option 1", "Option 2", "Option 3"];
  }

  static Settings _mockSettings() {
    return new Settings(options: _mockOptions());
  }
}
