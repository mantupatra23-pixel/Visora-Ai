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
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          const Text('Settings (placeholder)'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              if (st.jobId != null) {
                await st.startRenderJob(st.jobId!);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Render started')));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Create a job first')));
              }
            },
            child: const Text('Start Render'),
          ),
        ]),
      ),
    );
  }
}
