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
    final chars = st.characters;

    return Scaffold(
      appBar: AppBar(title: const Text("Characters")),
      body: ListView.builder(
        itemCount: chars.length,
        itemBuilder: (context, idx) {
          final c = chars[idx];
          return Card(
            child: ListTile(
              title: Text(c.name),
              subtitle: Text("Voice: ${c.voice}"),
              trailing: PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == "delete") {
                    setState(() {
                      chars.removeAt(idx);
                      st.setCharacters(chars);
                    });
                  }
                  if (v == "duplicate") {
                    final dup = CharacterModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: c.name + "_copy",
                      voice: c.voice,
                      outfit: c.outfit,
                    );
                    setState(() {
                      chars.add(dup);
                      st.setCharacters(chars);
                    });
                  }
                },
                itemBuilder: (context) =>
                    const [PopupMenuItem(value: "delete", child: Text("Delete")),
                      PopupMenuItem(value: "duplicate", child: Text("Duplicate"))],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final newChar = CharacterModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: "New Character",
            voice: "default",
            outfit: "default",
          );

          chars.add(newChar);
          st.setCharacters(chars);
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          child: const Text("Continue"),
          onPressed: () => Navigator.pushNamed(context, "/scenes"),
        ),
      ),
    );
  }
}
