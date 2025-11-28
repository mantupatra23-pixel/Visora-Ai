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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/script'),
              child: const Text('Create Video'),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Last Job Status'),
              subtitle: Text(st.currentJob?.status ?? 'No job'),
              trailing: st.currentJob != null
                  ? Text('${st.currentJob!.progress.toStringAsFixed(0)}%')
                  : null,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/characters'),
                  child: const Text('Characters'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/scenes'),
                  child: const Text('Scenes'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/render'),
                  child: const Text('Render Settings'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/status'),
                  child: const Text('Status'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
