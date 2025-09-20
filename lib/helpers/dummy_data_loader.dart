import 'dart:convert';
import 'package:flutter/services.dart';

class DummyDataLoader {
  /// Load a JSON file from assets and convert it to Map<String, dynamic>
  static Future<Map<String, dynamic>> loadJson(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return jsonDecode(jsonString);
  }
}
