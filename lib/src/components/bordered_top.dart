import 'package:metapersona/src/components/bordered_container_with_side.dart';
import 'package:flutter/material.dart';

class BorderedTop extends StatelessWidget {
  final double width;
  final Color? color;
  final Widget child;

  const BorderedTop(
      {Key? key, this.width = 3.0, this.color, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BorderedContainerWithSides(
      color: color,
      child: child,
      borderDirections: const [AxisDirection.up],
    );
  }
}
