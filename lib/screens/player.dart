import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // optional - add dependency in pubspec.yaml

/// Simple Video Player Screen
/// - If you pass a videoUrl via constructor, it will show it and allow "Open" (via url_launcher).
/// - If no videoUrl passed, it shows "No video available".
class VideoPlayerScreen extends StatelessWidget {
  final String? videoUrl;

  const VideoPlayerScreen({super.key, this.videoUrl});

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid URL')));
      return;
    }
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open URL')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Open failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final url = videoUrl;
    return Scaffold(
      appBar: AppBar(title: const Text('Player')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: url == null || url.isEmpty
              ? const Text('No video available yet', textAlign: TextAlign.center)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Video URL:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SelectableText(url, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Open Video (browser)'),
                      onPressed: () => _openUrl(context, url),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.copy),
                      label: const Text('Copy URL'),
                      onPressed: () {
                        // copy to clipboard
                        Clipboard.setData(ClipboardData(text: url));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('URL copied')));
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
