import 'package:flutter/material.dart';
import 'package:metapersona/src/metapersonas/meta_persona.dart';

class MetaPersonaView extends StatelessWidget {
  final MetaPersona persona;

  const MetaPersonaView({Key? key, required this.persona}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Image(image: NetworkImage(persona.profile.fullAvatarPath)),
          ],
        ),
        Text(persona.profile.firstName),
        Text(persona.profile.lastName),
      ],
    );
  }
}
