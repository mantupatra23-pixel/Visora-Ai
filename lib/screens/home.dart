import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Visora AI')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.video_call),
            label: const Text('Create Video'),
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            onPressed: () => Navigator.pushNamed(context, '/script'),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Recent renders'),
            subtitle: Text(st.currentJob?.id ?? 'No jobs yet'),
            trailing: st.currentJob == null ? null : TextButton(onPressed: () => Navigator.pushNamed(context, '/status'), child: const Text('Status')),
          ),
          const SizedBox(height: 12),
          ListTile(leading: const Icon(Icons.save), title: const Text('Draft scripts'), subtitle: Text(st.script.isEmpty ? 'No draft' : st.script.substring(0, st.script.length.clamp(0, 40)))),
          const Spacer(),
          const Text('Your renders will appear here', style: TextStyle(color: Colors.grey)),
        ]),
      ),
    );
  }
}
