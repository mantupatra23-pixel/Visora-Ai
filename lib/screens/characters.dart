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
    final list = st.characters.isEmpty ? [Character(name: 'Hero'), Character(name: 'Friend')] : st.characters;
    return Scaffold(
      appBar: AppBar(title: const Text('Characters')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: list.length + 1,
        itemBuilder: (context, idx) {
          if (idx == list.length) {
            return ElevatedButton.icon(icon: const Icon(Icons.add), label: const Text('Add New Character'), onPressed: () {
              setState(() {
                list.add(Character(name: 'New ${list.length+1}'));
                st.setCharacters(list);
              });
            });
          }
          final c = list[idx];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                TextFormField(initialValue: c.name, decoration: const InputDecoration(labelText: 'Name'), onChanged: (v) { c.name = v; st.setCharacters(list); }),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(child: DropdownButtonFormField(value: c.voice, items: ['Neutral','Male','Female','Kid','Elder'].map((s)=>DropdownMenuItem(value:s,child:Text(s))).toList(), onChanged: (v){c.voice=v!;st.setCharacters(list);} , decoration: const InputDecoration(labelText: 'Voice'))),
                  const SizedBox(width: 8),
                  Expanded(child: DropdownButtonFormField(value: c.outfit, items: ['Default','Casual','Formal','Sport'].map((s)=>DropdownMenuItem(value:s,child:Text(s))).toList(), onChanged: (v){c.outfit=v!;st.setCharacters(list);} , decoration: const InputDecoration(labelText: 'Outfit'))),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [TextButton(onPressed: (){ setState((){ list.removeAt(idx); st.setCharacters(list); }); }, child: const Text('Delete'))])
              ]),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(padding: const EdgeInsets.all(8), child: ElevatedButton(child: const Text('Next: Scene Builder'), onPressed: () => Navigator.pushNamed(context, '/scenes'))),
    );
  }
}
