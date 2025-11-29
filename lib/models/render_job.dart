class RenderJob {
  final String id;
  final String status;
  final double progress;
  final String? videoUrl;

  RenderJob({
    required this.id,
    required this.status,
    this.progress = 0.0,
    this.videoUrl,
  });

  factory RenderJob.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? json['job_id'] ?? '').toString();
    final status = (json['status'] ?? 'created').toString();
    double progress = 0.0;
    if (json['progress'] is num) progress = (json['progress'] as num).toDouble();
    final videoUrl = json['video_url'] ?? json['videoUrl'] ?? json['video'] ?? null;
    return RenderJob(id: id, status: status, progress: progress, videoUrl: videoUrl?.toString());
  }
}
