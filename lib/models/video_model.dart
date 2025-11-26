class VideoModel {
  final String id;
  final String title;
  final String thumbnail;
  final String videoUrl;
  final String status;
  final DateTime createdAt;

  VideoModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.videoUrl,
    required this.status,
    required this.createdAt,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Untitled',
      thumbnail: json['thumbnail'] ?? '',
      videoUrl: json['video_url'] ?? '',
      status: json['status'] ?? 'done',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
