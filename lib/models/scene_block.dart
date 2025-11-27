class SceneBlock {
  String id;
  String environment;
  String camera;
  String motion;
  Map<String, dynamic>? extra;

  SceneBlock({
    required this.id,
    required this.environment,
    required this.camera,
    required this.motion,
    this.extra,
  });

  factory SceneBlock.fromJson(Map<String, dynamic> j) {
    return SceneBlock(
      id: j['id'].toString(),
      environment: j['environment'] ?? '',
      camera: j['camera'] ?? '',
      motion: j['motion'] ?? '',
      extra: j['extra'] != null ? Map<String, dynamic>.from(j['extra']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'environment': environment,
        'camera': camera,
        'motion': motion,
        'extra': extra,
      };
}
