import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class ScriptInputScreen extends StatefulWidget {
  const ScriptInputScreen({super.key});

  @override
  State<ScriptInputScreen> createState() => _ScriptInputScreenState();
}

class _ScriptInputScreenState extends State<ScriptInputScreen> {
  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final st = context.watch<AppState>();
    _ctrl.text = st.script;
    return Scaffold(
      appBar: AppBar(title: const Text('Script Input')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _ctrl,
                maxLines: null,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Write script here...'),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      st.setScript(_ctrl.text);
                      Navigator.pushNamed(context, '/characters');
                    },
                    child: const Text('Next: Characters'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
