import 'package:flutter/material.dart';

class MainMenuCardItem extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPress;

  const MainMenuCardItem({Key? key, required this.child, this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Card(
        elevation: 10,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: child
          ),
        ),
      ),
    );
  }
}
