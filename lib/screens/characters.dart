import 'package:flutter/material.dart';
import 'dart:math';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  final nameCtrl = TextEditingController();
  final voiceCtrl = TextEditingController();
  final outfitCtrl = TextEditingController();

  // using simple Map to keep this file independent from model changes
  final List<Map<String, String>> _chars = [];

  String _newId() {
    // simple unique id (time + random)
    final t = DateTime.now().millisecondsSinceEpoch;
    final r = Random().nextInt(9999);
    return '$t$r';
  }

  void _addCharacter() {
    final name = nameCtrl.text.trim();
    final voice = voiceCtrl.text.trim();
    final outfit = outfitCtrl.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Name required')));
      return;
    }

    setState(() {
      _chars.add({
        'id': _newId(),
        'name': name,
        'voice': voice,
        'outfit': outfit,
      });
      nameCtrl.clear();
      voiceCtrl.clear();
      outfitCtrl.clear();
    });
  }

  void _removeCharacter(String id) {
    setState(() {
      _chars.removeWhere((m) => m['id'] == id);
    });
  }

  void _editCharacter(String id) {
    final idx = _chars.indexWhere((m) => m['id'] == id);
    if (idx == -1) return;

    nameCtrl.text = _chars[idx]['name'] ?? '';
    voiceCtrl.text = _chars[idx]['voice'] ?? '';
    outfitCtrl.text = _chars[idx]['outfit'] ?? '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit character'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: voiceCtrl, decoration: const InputDecoration(labelText: 'Voice')),
            TextField(controller: outfitCtrl, decoration: const InputDecoration(labelText: 'Outfit')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                nameCtrl.clear();
                voiceCtrl.clear();
                outfitCtrl.clear();
              },
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) return;
                setState(() {
                  _chars[idx] = {
                    'id': id,
                    'name': name,
                    'voice': voiceCtrl.text.trim(),
                    'outfit': outfitCtrl.text.trim(),
                  };
                });
                nameCtrl.clear();
                voiceCtrl.clear();
                outfitCtrl.clear();
                Navigator.pop(context);
              },
              child: const Text('Save')),
        ],
      ),
    );
  }

  // Optional: when leaving the screen you can return characters to caller
  void _done() {
    Navigator.pop(context, _chars);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    voiceCtrl.dispose();
    outfitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Characters'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Done',
            onPressed: _done,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // input form
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Name', hintText: 'Hero, Narrator, etc.'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: voiceCtrl,
              decoration: const InputDecoration(labelText: 'Voice', hintText: 'calm, deep, female...'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: outfitCtrl,
              decoration: const InputDecoration(labelText: 'Outfit', hintText: 'casual, formal...'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Character'),
                    onPressed: _addCharacter,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // list
            Expanded(
              child: _chars.isEmpty
                  ? const Center(child: Text('No characters yet. Add one above.'))
                  : ListView.separated(
                      itemCount: _chars.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (ctx, i) {
                        final c = _chars[i];
                        return ListTile(
                          title: Text(c['name'] ?? ''),
                          subtitle: Text('Voice: ${c['voice'] ?? '-'}  •  Outfit: ${c['outfit'] ?? '-'}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editCharacter(c['id']!),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _removeCharacter(c['id']!),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
