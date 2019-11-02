import 'package:redux/redux.dart';
import 'package:stronk/domain/model/user.dart';
import 'package:stronk/redux/state/app_state.dart';

class HomeVM {

  final User user;

  HomeVM(this.user);

  factory HomeVM.create(Store<AppState> store) {
    return HomeVM(store.state.user);
  }
}

