import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class RenderSettingsScreen extends StatelessWidget {
  const RenderSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final st = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Render Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Resolution: 1080p (default)'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await st.startRenderJob();
                Navigator.pushNamed(context, '/status');
              },
              child: const Text('Generate Video'),
            ),
          ],
        ),
      ),
    );
  }
}
