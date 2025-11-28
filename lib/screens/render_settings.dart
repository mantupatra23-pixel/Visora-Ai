import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class RenderSettingsScreen extends StatefulWidget {
  const RenderSettingsScreen({super.key});
  @override
  State<RenderSettingsScreen> createState() => _RenderSettingsScreenState();
}

class _RenderSettingsScreenState extends State<RenderSettingsScreen> {
  final TextEditingController _scriptCtrl = TextEditingController();
  bool _autoStart = true;

  @override
  void dispose() {
    _scriptCtrl.dispose();
    super.dispose();
  }

  Future<void> _createAndStart(BuildContext context) async {
    final st = Provider.of<AppState>(context, listen: false);
    final script = _scriptCtrl.text.trim();
    if (script.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Script required')));
      return;
    }

    try {
      await st.createVideoJob(
        script: script,
        // For now pass empty scene/character arrays - adapt to your UI
        scenes: [],
        characters: [],
      );

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job created')));
      if (_autoStart) {
        await st.startRender();
        Navigator.pushNamed(context, '/status');
      } else {
        // if not auto start, go to status page to start manually
        Navigator.pushNamed(context, '/status');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final st = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Render Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _scriptCtrl,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Script',
                hintText: 'Enter the script for the video',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Auto start render'),
                const Spacer(),
                Switch(value: _autoStart, onChanged: (v) => setState(() => _autoStart = v)),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: st.isBusy ? null : () => _createAndStart(context),
              child: st.isBusy ? const CircularProgressIndicator() : const Text('Create Video'),
            ),
            const SizedBox(height: 16),
            if (st.lastError != null) Text('Last error: ${st.lastError}', style: const TextStyle(color: Colors.red)),
            if (st.jobId != null) Text('Job: ${st.jobId}'),
          ],
        ),
      ),
    );
  }
}
