import 'package:metapersona/src/components/bordered_container_with_side.dart';
import 'package:flutter/material.dart';

class BorderedBottom extends StatelessWidget {
  final double width;
  final Color? color;
  final Widget child;

  const BorderedBottom(
      {Key? key, this.width = 3.0, this.color, required this.child}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return BorderedContainerWithSides(
      child: child,
      color: color,
      borderDirections: const [AxisDirection.down],
    );
  }
}
