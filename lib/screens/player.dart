// lib/screens/player.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class VideoPlayerScreen extends StatelessWidget {
  const VideoPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final st = context.watch<AppState>();

    final url = st.currentJob?.videoUrl;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rendered Video"),
        centerTitle: true,
      ),
      body: Center(
        child: url == null || url.isEmpty
            ? const Text(
                "Video not ready yet...",
                style: TextStyle(fontSize: 18),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Your video is ready!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  SelectableText(
                    url,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Open URL in browser (coming soon)"),
                        ),
                      );
                    },
                    child: const Text("Open Video"),
                  ),
                ],
              ),
      ),
    );
  }
}
