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