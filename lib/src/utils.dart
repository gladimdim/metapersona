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