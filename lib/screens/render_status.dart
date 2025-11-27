import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../services/api_service.dart';
import '../models/render_job.dart';

const backendBase = 'https://visora-backend-v2.onrender.com';

class RenderStatusScreen extends StatefulWidget {
  const RenderStatusScreen({super.key});
  @override
  State<RenderStatusScreen> createState() => _RenderStatusScreenState();
}

class _RenderStatusScreenState extends State<RenderStatusScreen> {
  final api = VisoraApi(base: backendBase);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _poll());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _poll() async {
    final st = Provider.of<AppState>(context, listen: false);
    final job = st.currentJob;
    if (job == null) return;
    try {
      final data = await api.getStatus(job.id);
      job.status = data['status'] ?? job.status;
      job.progress = (data['progress'] ?? job.progress).toDouble();
      st.setJob(job);
      if (job.status == 'done' || job.status == 'failed') _timer?.cancel();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final st = Provider.of<AppState>(context);
    final job = st.currentJob;
    return Scaffold(
      appBar: AppBar(title: const Text('Render Status')),
      body: job == null ? const Center(child: Text('No job')) : Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Text('Job: ${job.id}'),
          const SizedBox(height: 10),
          LinearProgressIndicator(value: job.progress/100),
          const SizedBox(height: 8),
          Text('${job.status} • ${job.progress.toStringAsFixed(0)}%'),
          const SizedBox(height: 12),
          Expanded(child: ListView(children: const [
            ListTile(title: Text('Script parsing'), subtitle: Text('...')),
            ListTile(title: Text('Character engine'), subtitle: Text('...')),
            ListTile(title: Text('Lipsync'), subtitle: Text('...')),
          ])),
          Row(children: [
            ElevatedButton(onPressed: job.status=='done' ? ()=>Navigator.pushNamed(context, '/player') : null, child: const Text('Open Player')),
            const SizedBox(width: 8),
            TextButton(onPressed: () { st.clearJob(); Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false); }, child: const Text('Cancel')),
          ])
        ]),
      ),
    );
  }
}
