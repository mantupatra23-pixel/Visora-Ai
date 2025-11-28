// lib/models/render_job.dart
class RenderJob {
  final String id;
  final String status; // created, queued, started, tts, lipsync, rendering, combining, completed, failed
  final double progress; // 0.0 - 100.0
  final String? videoUrl; // filled when completed
  final Map<String, dynamic>? raw; // optional raw payload

  RenderJob({
    required this.id,
    required this.status,
    required this.progress,
    this.videoUrl,
    this.raw,
  });

  factory RenderJob.fromJson(Map<String, dynamic> json) {
    // json may come as nested structure; adapt as needed
    final idVal = json['id']?.toString() ?? (json['job_id']?.toString() ?? '');
    final statusVal = json['status']?.toString() ?? 'created';
    final progressVal = (() {
      final p = json['progress'] ?? json['progress_percent'] ?? 0;
      try {
        return (p is num) ? p.toDouble() : double.parse(p.toString());
      } catch (_) {
        return 0.0;
      }
    })();

    final video = json['video_url'] ??
        json['videoUrl'] ??
        (json['result'] is Map ? json['result']['video_url'] : null);

    return RenderJob(
      id: idVal,
      status: statusVal,
      progress: progressVal,
      videoUrl: video?.toString(),
      raw: json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'progress': progress,
      'video_url': videoUrl,
    };
  }
}
