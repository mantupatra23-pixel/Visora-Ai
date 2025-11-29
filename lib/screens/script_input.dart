import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class ScriptInputScreen extends StatefulWidget {
  const ScriptInputScreen({super.key});

  @override
  State<ScriptInputScreen> createState() => _ScriptInputScreenState();
}

class _ScriptInputScreenState extends State<ScriptInputScreen> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final st = context.watch<AppState>();
    _ctrl.text = st.script;

    return Scaffold(
      appBar: AppBar(title: const Text('Script')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          TextField(
            controller: _ctrl,
            maxLines: 8,
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Paste script here'),
          ),
          const SizedBox(height: 12),
          Row(children: [
            ElevatedButton(
              onPressed: () {
                st.setScript(_ctrl.text);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Script saved')));
              },
              child: const Text('Save Script'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () async {
                // create job
                try {
                  final id = await st.startCreateJob();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Job created: $id')));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Create failed: $e')));
                }
              },
              child: const Text('Create Job'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {
                if (st.jobId != null) {
                  st.startRenderJob(st.jobId!);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Render started')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No job id')));
                }
              },
              child: const Text('Start Render'),
            ),
          ])
        ]),
      ),
    );
  }
}
