import 'dart:convert';
import 'package:flutter/services.dart';

class FFDevEnvironmentValues {
  static const String currentEnvironment = 'Production';
  static const String environmentValuesPath =
      'assets/environment_values/environment.json';

  static final FFDevEnvironmentValues _instance =
      FFDevEnvironmentValues._internal();

  factory FFDevEnvironmentValues() {
    return _instance;
  }

  FFDevEnvironmentValues._internal();

  Future<void> initialize() async {
    try {
      final String response =
          await rootBundle.loadString(environmentValuesPath);
      final data = await json.decode(response);
      _brevoKey = data['brevoKey'];
      _supabaseKey = data['supabaseKey'];
      _supabaseToken = data['supabaseToken'];
    } catch (e) {
      print('Error loading environment values: $e');
    }
  }

  String _brevoKey = '';
  String get brevoKey => _brevoKey;

  String _supabaseKey = '';
  String get supabaseKey => _supabaseKey;

  String _supabaseToken = '';
  String get supabaseToken => _supabaseToken;
}
