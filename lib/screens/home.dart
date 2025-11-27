import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/video_provider.dart';
import '../services/api_service.dart';
import '../widgets/video_card.dart';
import 'create.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Visora AI'),
          actions: [IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CreateScreen())), icon: Icon(Icons.create))],
        ),
        body: RefreshIndicator(
          onRefresh: () => Provider.of<VideoProvider>(context, listen: false).loadVideos(Provider.of<ApiService>(context, listen: false)),
          child: ListView(
            padding: EdgeInsets.all(12),
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text('Create video in 60s'),
                  subtitle: Text('AI script -> voice -> template'),
                  trailing: ElevatedButton(
                    child: Text('Create'),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CreateScreen())),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Text('Recent', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 8),
              if (provider.loading) Center(child: CircularProgressIndicator()),
              for (var v in provider.videos) VideoCard(video: v),
              if (provider.videos.isEmpty && !provider.loading) Padding(
                padding: EdgeInsets.only(top: 24),
                child: Center(child: Text('No videos yet. Tap Create.')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
