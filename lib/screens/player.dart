import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../models/video_model.dart';

class PlayerScreen extends StatefulWidget {
  final VideoModel video;
  const PlayerScreen({Key? key, required this.video}) : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController? _vp;
  ChewieController? _chewie;

  @override
  void initState() {
    super.initState();
    _vp = VideoPlayerController.network(widget.video.videoUrl)..initialize().then((_) {
      _chewie = ChewieController(videoPlayerController: _vp!, autoPlay: false, looping: false);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _chewie?.dispose();
    _vp?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.title),
      ),
      body: Column(
        children: [
          if (_chewie != null)
            AspectRatio(aspectRatio: _vp!.value.aspectRatio, child: Chewie(controller: _chewie!))
          else
            Container(height: 250, child: Center(child: CircularProgressIndicator())),
          ListTile(title: Text('Status: ${widget.video.status}'), subtitle: Text(widget.video.createdAt.toString())),
          Padding(
            padding: EdgeInsets.all(12),
            child: ElevatedButton.icon(onPressed: () {}, icon: Icon(Icons.download), label: Text('Download')),
          )
        ],
      ),
    );
  }
}
