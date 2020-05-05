import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';
import 'dart:io';

const DEBUG = !kReleaseMode;

// since dart doesn't support async contructor/factory
// a static config instance provides the best ergonomics
Config CONFIG;

class Config {
  Map _yaml;

  Config(String configText) {
    _yaml = loadYaml(configText);
  }

  // ignore: non_constant_identifier_names
  String get URI {
    return _yaml["server_uri"];
  }

}

Future<void> initializeConfig() async {
  var configText = await rootBundle.loadString('assets/config.yaml');
  CONFIG = Config(configText);
}


class UninitializedConfigException extends Exception {
  factory UninitializedConfigException() => Exception("Make sure the initialize the config before working with it");
}