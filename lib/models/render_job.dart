class RenderJob {
  final String id;
  String status;
  double progress;
  RenderJob({required this.id, this.status = 'queued', this.progress = 0});
}
