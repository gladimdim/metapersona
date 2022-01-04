import 'package:flutter/material.dart';
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
                        decoration: const InputDecoration(
                            hintText: "Enter full URL to the Meta Persona"),
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
                    .map((mp) => MetaPersonaView(persona: mp))
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
}
