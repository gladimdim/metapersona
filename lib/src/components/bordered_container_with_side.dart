import 'package:flutter/material.dart';

class BorderedContainerWithSides extends StatelessWidget {
  final double width;
  final Color? color;
  final Widget child;
  late final List<AxisDirection> borderDirections;

  BorderedContainerWithSides({Key? key,
    this.width = 3.0,
    this.color,
    required this.child,
    List<AxisDirection>? borderDirections,
  }): super(key: key) {
    this.borderDirections = borderDirections ?? [AxisDirection.up];
  }

  BorderSide _sidesForDirection(AxisDirection dir, BuildContext context) {
    final directions = {
      AxisDirection.up:
          borderDirections.contains(AxisDirection.up) ? _side(context) : BorderSide.none,
      AxisDirection.down:
          borderDirections.contains(AxisDirection.down) ? _side(context) : BorderSide.none,
      AxisDirection.left:
          borderDirections.contains(AxisDirection.left) ? _side(context) : BorderSide.none,
      AxisDirection.right:
          borderDirections.contains(AxisDirection.right) ? _side(context) : BorderSide.none,
    };

    return directions[dir]!;
  }

  BorderSide _side(BuildContext context) {
    final defaultColor = Theme.of(context).primaryColor;
    return BorderSide(width: width, color: color ?? defaultColor);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: _sidesForDirection(AxisDirection.down, context),
          top: _sidesForDirection(AxisDirection.up, context),
          left: _sidesForDirection(AxisDirection.left, context),
          right: _sidesForDirection(AxisDirection.right, context),
        ),
      ),
      child: child,
    );
  }
}
