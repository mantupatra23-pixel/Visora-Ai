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
      appBar: AppBar(title: const Text('Player')),
      body: Center(
        child: url == null
            ? const Text('No video available yet')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Video URL:'),
                  Text(url),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      // open in browser
                      // use url_launcher if needed (not added here)
                    },
                    child: const Text('Open Video'),
                  )
                ],
              ),
      ),
    );
  }
}
