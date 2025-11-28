class RenderJob {
  final String id;
  final String status;
  final double progress;
  final String? videoUrl;

  RenderJob({required this.id, required this.status, required this.progress, this.videoUrl});

  factory RenderJob.fromJson(Map<String, dynamic> json) {
    return RenderJob(
      id: json['job_id']?.toString() ?? json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'created',
      progress: (json['progress'] != null) ? double.tryParse(json['progress'].toString()) ?? 0.0 : 0.0,
      videoUrl: json['video_url'] ?? json['videoUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'job_id': id,
    'status': status,
    'progress': progress,
    'video_url': videoUrl,
  };
}
