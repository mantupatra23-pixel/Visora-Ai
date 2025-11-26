import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/video_model.dart';

class VideoProvider extends ChangeNotifier {
  List<VideoModel> videos = [];
  bool loading = false;

  Future<void> loadVideos(ApiService api) async {
    loading = true;
    notifyListeners();
    try {
      final list = await api.fetchVideos();
      videos = list.map((e) => VideoModel.fromJson(e)).toList();
    } catch (e) {
      // handle
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void addVideo(VideoModel v) {
    videos.insert(0, v);
    notifyListeners();
  }
}
