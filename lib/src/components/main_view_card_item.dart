import 'package:flutter/material.dart';
class MainMenuCardItem extends StatelessWidget {
  final String text;
  final VoidCallback? onPress;
  const MainMenuCardItem({Key? key, required this.text, this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Card(
        elevation: 10,
        color: Theme.of(context).secondaryHeaderColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text, style: Theme.of(context).textTheme.subtitle1,),
          ),
        ),
      ),
    );
  }
}
