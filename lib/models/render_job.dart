class RenderJob {
  String id;        // required in UI
  String jobId;     // backend ID
  String status;
  int progress;

  RenderJob({
    required this.id,
    required this.jobId,
    required this.status,
    required this.progress,
  });

  factory RenderJob.fromJson(Map<String, dynamic> json) {
    return RenderJob(
      id: json["_id"] ?? json["id"] ?? "",
      jobId: json["jobId"] ?? "",
      status: json["status"] ?? "pending",
      progress: json["progress"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "jobId": jobId,
        "status": status,
        "progress": progress,
      };
}
