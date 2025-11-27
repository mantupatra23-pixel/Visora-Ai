class RenderJob {
  String jobId;
  String status;
  int progress;

  RenderJob({
    required this.jobId,
    required this.status,
    required this.progress,
  });

  factory RenderJob.fromJson(Map<String, dynamic> json) {
    return RenderJob(
      jobId: json["jobId"] ?? "",
      status: json["status"] ?? "pending",
      progress: json["progress"] ?? 0,
    );
  }
}
