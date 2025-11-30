import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter/services.dart';

import '../state/app_state.dart';

class VideoPlayerScreen extends StatelessWidget {
  const VideoPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final st = context.watch<AppState>();
    final url = st.videoUrl; // nullable

    return Scaffold(
      appBar: AppBar(title: const Text('Player')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: url == null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('No video available yet'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        // helpful action: open render status
                        Navigator.of(context).pushNamed('/status');
                      },
                      child: const Text('Open Status'),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Video URL:'),
                    const SizedBox(height: 8),
                    SelectableText(url, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    if (st.isPolling) const CircularProgressIndicator(),
                    if (st.lastError != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Error: ${st.lastError}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      )
                    ],
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            // open in browser (download or play in external app)
                            try {
                              if (await canLaunchUrlString(url)) {
                                await launchUrlString(url, mode: LaunchMode.externalApplication);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Cannot open URL')),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Open failed: $e')),
                              );
                            }
                          },
                          child: const Text('Open in browser'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // copy to clipboard
                            try {
                              await Clipboard.setData(ClipboardData(text: url));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('URL copied to clipboard')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Copy failed: $e')),
                              );
                            }
                          },
                          child: const Text('Copy URL'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // attempt download by opening in browser (Android will show download)
                            try {
                              if (await canLaunchUrlString(url)) {
                                await launchUrlString(url, mode: LaunchMode.externalApplication);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Opened in browser to download')),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Cannot open for download')),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Download/open failed: $e')),
                              );
                            }
                          },
                          child: const Text('Download'),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
