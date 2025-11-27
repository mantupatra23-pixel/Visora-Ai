import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../services/api_service.dart';
import '../models/character.dart';
import '../models/scene_block.dart';
import '../models/render_job.dart';

const backendBase = 'https://visora-backend-v2.onrender.com'; // change if needed

class RenderSettingsScreen extends StatefulWidget {
  const RenderSettingsScreen({super.key});
  @override
  State<RenderSettingsScreen> createState() => _RenderSettingsScreenState();
}

class _RenderSettingsScreenState extends State<RenderSettingsScreen> {
  String resolution = '1080p';
  String style = 'Realistic';
  int fps = 30;
  String output = 'Horizontal';
  bool ultra = false;
  bool _isRendering = false;
  final api = VisoraApi(base: backendBase);

  Future<void> _startRender(BuildContext ctx) async {
    final st = Provider.of<AppState>(ctx, listen: false);
    setState(() => _isRendering = true);
    try {
      final project = await api.createProject(
        script: st.script,
        characters: st.characters.map((c) => c.toJson()).toList(),
        scenes: st.scenes.map((s) => s.toJson()).toList(),
        renderSettings: {'resolution': resolution, 'style': style, 'fps': fps, 'output': output, 'ultra': ultra},
      );
      final projectId = project['projectId'] ?? project['id'] ?? 'proj-${DateTime.now().millisecondsSinceEpoch}';
      final start = await api.startRender(projectId);
      final jobId = start['jobId'] ?? start['id'] ?? 'job-${DateTime.now().millisecondsSinceEpoch}';
      st.setJob(RenderJob(id: jobId, status: 'started', progress: 0));
      Navigator.pushReplacementNamed(ctx, '/status');
    } catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Render failed: $e')));
    } finally { if (mounted) setState(() => _isRendering = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Render Settings')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          DropdownButtonFormField(value: resolution, items: ['1080p','2K','4K'].map((s)=>DropdownMenuItem(value:s,child:Text(s))).toList(), onChanged: (v)=>setState(()=>resolution=v!)),
          const SizedBox(height: 8),
          DropdownButtonFormField(value: style, items: ['Realistic','Cinematic','Cartoon','Anime','Pixar-style'].map((s)=>DropdownMenuItem(value:s,child:Text(s))).toList(), onChanged: (v)=>setState(()=>style=v!)),
          const SizedBox(height: 8),
          Row(children: [const Text('FPS:'), const SizedBox(width: 12), DropdownButton(value: fps, items: [24,30,60].map((n)=>DropdownMenuItem(value:n,child:Text('$n'))).toList(), onChanged: (v)=>setState(()=>fps=v!)), const Spacer(), const Text('Ultra GPU'), Switch(value: ultra, onChanged: (v)=>setState(()=>ultra=v))]),
          const Spacer(),
          ElevatedButton(child: _isRendering ? const Text('Starting...') : const Text('Generate Video'), onPressed: _isRendering ? null : ()=>_startRender(context)),
        ]),
      ),
    );
  }
}
