import 'package:flutter/material.dart';
import 'package:metapersona/src/full_profile_view/full_profile_view.dart';
import 'package:metapersona/src/localization/my_localization.dart';
import 'package:metapersona/src/metapersonas/meta_persona.dart';
import 'package:metapersona/src/metapersonas/metapersona_view.dart';
import 'package:metapersona/src/utils.dart';

class MetaPersonasPage extends StatefulWidget {
  static const String routeName = "/";

  const MetaPersonasPage({Key? key}) : super(key: key);

  @override
  _MetaPersonasPageState createState() => _MetaPersonasPageState();
}

class _MetaPersonasPageState extends State<MetaPersonasPage> {
  final TextEditingController _textEditingController = TextEditingController();
  Map<String, MetaPersona> metaPersonas = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.labelListMetaPersonas),
      ),
      body: Center(
        child: Column(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 9,
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.hintEnterFullMetaPersonaUrl),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: _fetchProfile,
                        icon: const Icon(Icons.find_in_page),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: metaPersonas.values
                    .map(
                      (mp) => InkWell(
                        child: MetaPersonaView(persona: mp),
                        onTap: () {
                          _navigateToMetaPersonaProfile(mp);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _fetchProfile() async {
    var mp = await MetaPersona.initFromUrl("https://dmytrogladkyi.com");
    setState(() {
      metaPersonas[mp.fullPath] = mp;
    });
  }

  void _navigateToMetaPersonaProfile(MetaPersona mp) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FullProfileView(persona: mp);
    }));
  }
}
