import 'package:metapersona/src/components/bordered_container_with_side.dart';
import 'package:flutter/material.dart';

class BorderedAll extends StatelessWidget {
  final double width;
  final Widget child;

  const BorderedAll(
      {this.width = 3.0, required this.child});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
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
