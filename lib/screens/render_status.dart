import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class RenderStatusScreen extends StatelessWidget {
  const RenderStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final st = context.watch<AppState>();
    final job = st.currentJob;

    return Scaffold(
      appBar: AppBar(title: const Text('Render Status')),
      body: Center(
        child: job == null
            ? const Text('No job running')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Job: ${job.id}'),
                  const SizedBox(height: 8),
                  Text('Status: ${job.status}'),
                  const SizedBox(height: 8),
                  Text('Progress: ${job.progress.toStringAsFixed(0)}%'),
                  const SizedBox(height: 16),
                  if (job.videoUrl != null)
                    ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/player'),
                        child: const Text('Open Video')),
                ],
              ),
      ),
    );
  }
}
