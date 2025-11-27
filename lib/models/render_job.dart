// lib/models/render_job.dart
class RenderJob {
  final String id;
  final String status;
  final int progress;

  RenderJob({
    required this.id,
    required this.status,
    required this.progress,
  });

  factory RenderJob.fromJson(Map<String, dynamic> json) {
    // backend might use 'jobId' or 'id' — handle both
    final idValue = json['jobId'] ?? json['id'] ?? '';
    final statusValue = json['status'] ?? 'pending';
    final progressValue = (json['progress'] is int)
        ? json['progress'] as int
        : int.tryParse('${json['progress'] ?? 0}') ?? 0;

    return RenderJob(
      id: idValue.toString(),
      status: statusValue.toString(),
      progress: progressValue,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'progress': progress,
      };

  @override
  String toString() => 'RenderJob(id: $id, status: $status, progress: $progress)';
}
