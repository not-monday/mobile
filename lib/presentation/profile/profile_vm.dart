import 'package:redux/redux.dart';
import 'package:stronk/domain/model/user.dart';
import 'package:stronk/redux/state/app_state.dart';

class ProfileVM {

  final User user;

  ProfileVM(this.user);

  factory ProfileVM.create(Store<AppState> store) {
    return ProfileVM(store.state.user);
  }
}

