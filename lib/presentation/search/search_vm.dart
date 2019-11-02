import 'package:redux/redux.dart';
import 'package:stronk/domain/model/user.dart';
import 'package:stronk/redux/state/app_state.dart';

class SearchVM {

  final User user;

  SearchVM(this.user);

  factory SearchVM.create(Store<AppState> store) {
    return SearchVM(store.state.user);
  }
}

