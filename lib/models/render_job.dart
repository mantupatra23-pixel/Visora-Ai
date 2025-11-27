// lib/models/render_job.dart
class RenderJob {
  String id;
  String status;
  double progress;
  String? resultUrl;

  RenderJob({
    required this.id,
    this.status = 'queued',
    this.progress = 0.0,
    this.resultUrl,
  });

  factory RenderJob.fromJson(Map<String, dynamic> j) {
    return RenderJob(
      id: j['id']?.toString() ?? '',
      status: j['status'] ?? 'queued',
      progress: ((j['progress'] ?? 0) as num).toDouble(),
      resultUrl: j['resultUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'progress': progress,
        'resultUrl': resultUrl,
      };
}
