import 'package:redux/redux.dart';
import 'package:stronk/domain/model/user.dart';
import 'package:stronk/redux/state/app_state.dart';

class SettingsVM {

  final User user;

  SettingsVM(this.user);

  factory SettingsVM.create(Store<AppState> store) {
    return SettingsVM(store.state.user);
  }
}

