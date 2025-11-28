import 'package:flutter/material.dart';
import '../models/character.dart';
import '../state/app_state.dart';
import 'package:provider/provider.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  final nameCtrl = TextEditingController();
  final voiceCtrl = TextEditingController();
  final outfitCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final st = context.watch<AppState>();
    final list = st.characters;

    return Scaffold(
      appBar: AppBar(title: const Text("Characters")),
      body: Column(
        children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Name")),
          TextField(controller: voiceCtrl, decoration: const InputDecoration(labelText: "Voice")),
          TextField(controller: outfitCtrl, decoration: const InputDecoration(labelText: "Outfit")),

          ElevatedButton(
            onPressed: () {
              final c = CharacterModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameCtrl.text,
                voice: voiceCtrl.text,
                outfit: outfitCtrl.text,
              );
              st.addCharacter(c);
            },
            child: const Text("Add Character"),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, i) {
                final c = list[i];
                return ListTile(
                  title: Text(c.name),
                  subtitle: Text("${c.voice} | ${c.outfit}"),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
