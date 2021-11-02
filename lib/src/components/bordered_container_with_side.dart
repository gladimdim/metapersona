import 'package:flutter/material.dart';

class BorderedContainerWithSides extends StatelessWidget {
  final double width;
  final Color color;
  final Widget child;
  late final List<AxisDirection> borderDirections;

  BorderedContainerWithSides({
    this.width = 3.0,
    this.color = Colors.black,
    required this.child,
    List<AxisDirection>? borderDirections,
  }) {
    this.borderDirections = borderDirections ?? [AxisDirection.up];
  }

  Map<AxisDirection, BorderSide> get _sidesForDirection {
    return {
      AxisDirection.up:
          borderDirections.contains(AxisDirection.up) ? _side : BorderSide.none,
      AxisDirection.down:
          borderDirections.contains(AxisDirection.down) ? _side : BorderSide.none,
      AxisDirection.left:
          borderDirections.contains(AxisDirection.left) ? _side : BorderSide.none,
      AxisDirection.right:
          borderDirections.contains(AxisDirection.right) ? _side : BorderSide.none,
    };
  }

  BorderSide get _side {
    return BorderSide(width: width, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: _sidesForDirection[AxisDirection.down]!,
          top: _sidesForDirection[AxisDirection.up]!,
          left: _sidesForDirection[AxisDirection.left]!,
          right: _sidesForDirection[AxisDirection.right]!,
        ),
      ),
      child: child,
    );
  }
}
