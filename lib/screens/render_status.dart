import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import 'package:url_launcher/url_launcher.dart';

class RenderStatusScreen extends StatelessWidget {
  const RenderStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final st = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Render Status')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Job: ${st.jobId ?? "-"}'),
            const SizedBox(height: 8),
            Text('Status: ${st.status}'),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: st.progress),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: st.jobId == null ? null : () => st.pollStatusOnce(),
                  child: const Text('Refresh'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: st.jobId == null ? null : () => st.startPolling(),
                  child: const Text('Start Polling'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: st.jobId == null ? null : () => st.stopPolling(),
                  child: const Text('Stop Polling'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: st.jobId == null ? null : () => st.clearJob(),
                  child: const Text('Clear'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (st.status == 'completed' && st.videoUrl != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Video ready:'),
                  const SizedBox(height: 8),
                  SelectableText(st.videoUrl ?? ''),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final url = st.videoUrl!;
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot open URL')));
                      }
                    },
                    child: const Text('Open Video'),
                  ),
                ],
              ),
            if (st.lastError != null) Text('Error: ${st.lastError}', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            Expanded(child: SingleChildScrollView(child: Text('Job data:\n${st.jobData ?? {}}'))),
          ],
        ),
      ),
    );
  }
}
