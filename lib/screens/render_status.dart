import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class RenderStatusScreen extends StatelessWidget {
  const RenderStatusScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = context.watch<AppState>();
    final job = st.currentJob;
    final progress = job?.progress ?? 0.0;
    final status = job?.status ?? (st.jobData != null ? (st.jobData!['status'] ?? '') : '');

    return Scaffold(
      appBar: AppBar(title: const Text('Render Status')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Job ID: ${st.jobId ?? '-'}'),
            const SizedBox(height: 8),
            Text('Status: ${status ?? '-'}'),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (st.jobId != null) st.pollRenderStatus(st.jobId!);
                  },
                  child: const Text('Poll Status'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (st.jobId != null) st.startPolling(st.jobId!);
                  },
                  child: const Text('Start Polling'),
                ),
                ElevatedButton(
                  onPressed: () => st.stopPolling(),
                  child: const Text('Stop Polling'),
                ),
                ElevatedButton(
                  onPressed: () => st.clearJob(),
                  child: const Text('Clear Job'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (st.lastError != null) Text('Error: ${st.lastError}', style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
