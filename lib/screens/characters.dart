import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/character.dart';

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
  void dispose() {
    nameCtrl.dispose();
    voiceCtrl.dispose();
    outfitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final st = context.watch<AppState>();
    final list = st.characters;

    return Scaffold(
      appBar: AppBar(title: const Text('Characters')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
          TextField(controller: voiceCtrl, decoration: const InputDecoration(labelText: 'Voice')),
          TextField(controller: outfitCtrl, decoration: const InputDecoration(labelText: 'Outfit')),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              final c = CharacterModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameCtrl.text,
                voice: voiceCtrl.text,
                outfit: outfitCtrl.text,
              );
              st.addCharacter(c.toJson());
              nameCtrl.clear();
              voiceCtrl.clear();
              outfitCtrl.clear();
            },
            child: const Text('Add Character'),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, i) {
                final c = list[i];
                final name = c['name'] ?? c['name'];
                return ListTile(
                  title: Text(name ?? 'Character'),
                  subtitle: Text('Voice: ${c['voice'] ?? ''} • Outfit: ${c['outfit'] ?? ''}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => st.removeCharacterAt(i),
                  ),
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
