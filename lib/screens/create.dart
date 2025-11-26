import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../services/api_service.dart';
import '../providers/video_provider.dart';
import '../models/video_model.dart';
import 'dart:async';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _controller = TextEditingController();
  String _quality = 'sd';
  bool _working = false;
  Timer? _pollTimer;

  @override
  void dispose() {
    _controller.dispose();
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _startGeneration() async {
    final script = _controller.text.trim();
    if (script.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter script first')));
      return;
    }
    setState(() => _working = true);
    final api = Provider.of<ApiService>(context, listen: false);
    try {
      final res = await api.createGeneration(script: script, quality: _quality);
      final jobId = res['job_id'] ?? res['id'] ?? Uuid().v4();
      // show progress dialog
      _showProgress(jobId);
      _pollTimer = Timer.periodic(Duration(seconds: 3), (t) async {
        final status = await api.getJobStatus(jobId);
        final s = status['status'] ?? 'processing';
        if (s == 'done' || s == 'failed') {
          t.cancel();
          Navigator.of(context).pop(); // close progress
          setState(() => _working = false);
          if (s == 'done') {
            final videoJson = status['video'] ?? status['result'] ?? {};
            final v = VideoModel.fromJson(videoJson);
            Provider.of<VideoProvider>(context, listen: false).addVideo(v);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Video ready!')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Generation failed')));
          }
        }
      });
    } catch (e) {
      setState(() => _working = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _showProgress(String jobId) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Generating…'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Job id: $jobId\nThis may take ~30-120s'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Close'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              minLines: 4,
              maxLines: 8,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Paste your script here...',
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _quality,
                    items: [
                      DropdownMenuItem(child: Text('SD (fast)'), value: 'sd'),
                      DropdownMenuItem(child: Text('HD'), value: 'hd'),
                      DropdownMenuItem(child: Text('UHD'), value: 'uhd'),
                    ],
                    onChanged: (v) => setState(() => _quality = v ?? 'sd'),
                    decoration: InputDecoration(labelText: 'Quality'),
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _working ? null : _startGeneration,
                  child: Text(_working ? 'Working…' : 'Generate'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
