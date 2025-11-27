class RenderJob {
  String id;
  String status;
  double progress;
  String? videoUrl;

  RenderJob({
    required this.id,
    required this.status,
    required this.progress,
    this.videoUrl,
  });

  factory RenderJob.fromJson(Map<String, dynamic> json) {
    return RenderJob(
      id: json['id'] ?? '',
      status: json['status'] ?? 'queued',
      progress: (json['progress'] ?? 0).toDouble(),
      videoUrl: json['videoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "status": status,
      "progress": progress,
      "videoUrl": videoUrl,
    };
  }
}
