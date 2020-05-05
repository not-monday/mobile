import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:stronk/api/settings_repo.dart';
import 'package:stronk/domain/model/user.dart';

class SettingsState {
  final User userName;
  final List<String> options;


  SettingsState({this.userName,
                 @required this.options});

  @override
  String toString() {
    return ("\n name: $userName\n");
  }

}

@sealed
abstract class _Event {}

class InitEvent implements _Event {}

class UpdateInfoEvent implements _Event {}

class SettingsBloc extends Bloc<_Event, SettingsState> {
  final SettingsRepository settingsRepository;

  @override
  SettingsState get initialState => new SettingsState(
    options: []
  );

  @override
  Stream<SettingsState> mapEventToState(_Event event) async* {
    var newState = state;
    if (event is InitEvent) {
      newState = await handleInit();
    }
    yield newState;
  }

  SettingsBloc({@required this.settingsRepository}){
    add(new InitEvent());
  }

  Future<SettingsState> handleInit() async {
      final settings = await settingsRepository.retrieveSettings();
      return new SettingsState(options: settings.options);
  }
}
