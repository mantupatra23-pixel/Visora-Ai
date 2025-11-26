import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/video_provider.dart';
import '../widgets/video_card.dart';
import '../services/api_service.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  bool _init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_init) {
      final api = Provider.of<ApiService>(context, listen: false);
      Provider.of<VideoProvider>(context, listen: false).loadVideos(api);
      _init = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VideoProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Gallery')),
      body: provider.loading
          ? Center(child: CircularProgressIndicator())
          : provider.videos.isEmpty
              ? Center(child: Text('No videos yet'))
              : ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: provider.videos.length,
                  itemBuilder: (ctx, i) => VideoCard(video: provider.videos[i]),
                ),
    );
  }
}
