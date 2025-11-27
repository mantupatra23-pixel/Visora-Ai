import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/video_provider.dart';
import '../widgets/primary_button.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _controller = TextEditingController(text: 'Type your script here (Hindi/English)...');

  @override
  Widget build(BuildContext context) {
    final vp = context.watch<VideoProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Create Video')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(height: 12),
          vp.loading
              ? const CircularProgressIndicator()
              : PrimaryButton(
                  label: 'Generate Video',
                  onTap: () async {
                    await context.read<VideoProvider>().createFromScript(_controller.text.trim());
                    if (context.read<VideoProvider>().lastJobId != null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Render submitted')));
                      Navigator.of(context).pop();
                    } else if (context.read<VideoProvider>().error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${context.read<VideoProvider>().error}')));
                    }
                  },
                ),
        ]),
      ),
    );
  }
}
