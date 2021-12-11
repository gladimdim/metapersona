import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';

String getRootUrlPrefix() {
  return "/";
}
const cWidthThreshold = 800;

bool isNarrow(BuildContext context) {
  return MediaQuery.of(context).size.width < cWidthThreshold;
}

double calculatePaddings(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return width / 10;
}

int gridPerAxisCount(BuildContext context) {
  var width = MediaQuery.of(context).size.width;
  if (width > 1600) {
    return 3;
  }
  if (width < 800) {
    return 1;
  }

  return 2;
}

List<String> getUrlLinksFromMarkdown(String input) {
  var first = input.indexOf("](");
  if (first < 0) {
    return [];
  }
  List<int> points = [];
  int next = first;
  while (next >= 0) {
    points.add(next);
    next = input.indexOf("](", next+1);
  }

  List<String> result = [];

  for (var element in points) {
    var endPoint = input.indexOf(")", element);
    if (endPoint > 0) {
      var string = input.substring(element + 2, input.indexOf(")", element));
      result.add(string);
    }
  }

  return result;
}

int getDaysAgo({required DateTime from}) {
  var now = DateTime.now();

  var diff = now.difference(from);
  return diff.inDays;

}

class Parser {
  Parser(this.jsonString);
  final String jsonString;

  Future<Map> parseJsonInIsolate() async {
    final p = ReceivePort();
    await Isolate.spawn(_parseJson, p.sendPort);
    return await p.first;
  }

  Future _parseJson(SendPort p) async {
    final data = jsonDecode(jsonString);
    Isolate.exit(p, data);
  }
}