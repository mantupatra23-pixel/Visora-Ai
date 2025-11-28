class RenderJob {
  final String id;
  String status;
  double progress;
  String? videoUrl;

  RenderJob({
    required this.id,
    this.status = 'created',
    this.progress = 0.0,
    this.videoUrl,
  });

  factory RenderJob.fromJson(Map<String, dynamic> json) => RenderJob(
        id: json['id'].toString(),
        status: json['status'] ?? 'created',
        progress: ((json['progress'] ?? 0) as num).toDouble(),
      )..videoUrl = json['video_url'] ?? json['videoUrl'] ?? null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'progress': progress,
        'video_url': videoUrl,
      };
}
