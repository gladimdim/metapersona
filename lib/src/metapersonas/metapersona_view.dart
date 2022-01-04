import 'package:flutter/material.dart';
import 'package:metapersona/src/components/bordered_bottom.dart';
import 'package:metapersona/src/metapersonas/meta_persona.dart';

class MetaPersonaView extends StatelessWidget {
  final MetaPersona persona;

  const MetaPersonaView({Key? key, required this.persona}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BorderedBottom(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(45),
                ),
                child: Image(image: NetworkImage(persona.fullAvatarPath), width: 128,)
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "${persona.profile.firstName} ${persona.profile.lastName}",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    "Flutter Developer 💙 since 2018",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    "JavaScript developer since 2012",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
