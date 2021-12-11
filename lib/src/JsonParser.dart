import 'dart:convert';

import 'package:flutter/foundation.dart';

class Parser {
  Future<Map<String, dynamic>> parseJsonInIsolate(String input) async {
    return compute(_parseJson, input);
  }

  Map<String, dynamic> _parseJson(String input) {
    Map<String, dynamic> data = jsonDecode(input);
    return data;
  }
}