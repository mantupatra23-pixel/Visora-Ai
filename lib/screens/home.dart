import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final st = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Visora AI')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/script'),
              child: const Text('Create Video'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Last Job Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('${(st.currentJob?.progress ?? 0 * 100).toStringAsFixed(0)}%'),
              ],
            ),
            const SizedBox(height: 6),
            Text(st.currentJob?.status ?? 'created'),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/characters'), child: const Text('Characters')),
                ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/scenes'), child: const Text('Scenes')),
                ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/render_settings'), child: const Text('Render Settings')),
                ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/status'), child: const Text('Status')),
                ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/player'), child: const Text('Player')),
              ],
            ),
            const SizedBox(height: 20),
            if (st.lastError != null) Text('Error: ${st.lastError}', style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
