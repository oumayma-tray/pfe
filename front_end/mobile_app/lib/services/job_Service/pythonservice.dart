import 'package:flutter/services.dart';

class PythonScriptService {
  static const platform = MethodChannel('com.mobile_app.flutter/python');

  Future<int> calculateScore(String filePath, List<String> skills) async {
    try {
      final int result = await platform.invokeMethod('calculateScore', {
        'filePath': filePath,
        'skills': skills,
      });
      return result;
    } on PlatformException catch (e) {
      print("Failed to calculate score: '${e.message}'.");
      return 0;
    }
  }
}
