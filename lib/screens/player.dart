import 'package:flutter/material.dart';

class VideoPlayerScreen extends StatelessWidget {
  const VideoPlayerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // placeholder; integrate video_player or chewie for production
    return Scaffold(
      appBar: AppBar(title: const Text('Player')),
      body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 320, height: 180, color: Colors.black12, child: const Center(child: Icon(Icons.play_circle_outline, size: 64))),
        const SizedBox(height: 12),
        ElevatedButton.icon(icon: const Icon(Icons.download), label: const Text('Download MP4'), onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Download stub'))); }),
        const SizedBox(height: 8),
        ElevatedButton.icon(icon: const Icon(Icons.share), label: const Text('Share'), onPressed: () {}),
      ])),
    );
  }
}
