import 'package:flutter/cupertino.dart';

String getRootUrlPrefix() {
  return "/";
}
const cWidthThreshold = 800;

bool isNarrow(BuildContext context) {
  return MediaQuery.of(context).size.width < cWidthThreshold;
}