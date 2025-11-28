import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class VoiceLipsyncScreen extends StatelessWidget {
  const VoiceLipsyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final st = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Voice & Lipsync')),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Pick voice and lipsync profile (placeholder)'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/render'),
              child: const Text('Next: Render Settings'),
            )
          ],
        ),
      ),
    );
  }
}
