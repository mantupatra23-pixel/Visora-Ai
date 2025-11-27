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
  @override
  Widget build(BuildContext context) {
    final st = Provider.of<AppState>(context);
    final list = st.characters;

    return Scaffold(
      appBar: AppBar(title: const Text('Characters')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: list.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, idx) {
          final c = list[idx];
          return ListTile(
            title: Text(c.name),
            subtitle: Text('Voice: ${c.voice} • Outfit: ${c.outfit}'),
            trailing: PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'delete') {
                  setState(() {
                    st.characters.removeAt(idx);
                    st.setCharacters(List.from(st.characters));
                  });
                } else if (v == 'edit') {
                  final nameCtrl = TextEditingController(text: c.name);
                  final voiceCtrl = TextEditingController(text: c.voice);
                  final outfitCtrl = TextEditingController(text: c.outfit);
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Edit Character'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
                          TextField(controller: voiceCtrl, decoration: const InputDecoration(labelText: 'Voice')),
                          TextField(controller: outfitCtrl, decoration: const InputDecoration(labelText: 'Outfit')),
                        ],
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              c.name = nameCtrl.text;
                              c.voice = voiceCtrl.text;
                              c.outfit = outfitCtrl.text;
                              st.setCharacters(List.from(st.characters));
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  );
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          final nameCtrl = TextEditingController(text: 'Character ${st.characters.length + 1}');
          final voiceCtrl = TextEditingController(text: 'default');
          final outfitCtrl = TextEditingController(text: 'default');
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Add Character'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
                  TextField(controller: voiceCtrl, decoration: const InputDecoration(labelText: 'Voice')),
                  TextField(controller: outfitCtrl, decoration: const InputDecoration(labelText: 'Outfit')),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    final c = CharacterModel(
                      id: id,
                      name: nameCtrl.text,
                      voice: voiceCtrl.text,
                      outfit: outfitCtrl.text,
                    );
                    setState(() {
                      st.addCharacter(c);
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
