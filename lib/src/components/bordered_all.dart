import 'package:metapersona/src/components/bordered_container_with_side.dart';
import 'package:flutter/material.dart';

class BorderedAll extends StatelessWidget {
  final double width;
  final Widget child;
  final Color? color;
  const BorderedAll(
      {Key? key, this.width = 3.0, required this.child, this.color}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return BorderedContainerWithSides(
      child: child,
      width: width,
      color: color,
      borderDirections: const [
        AxisDirection.down,
        AxisDirection.up,
        AxisDirection.left,
        AxisDirection.right
      ],
    );
  }
}
