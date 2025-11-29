class SceneModel {
  final String id;
  final String name;
  final String environment;
  final String camera;
  final String motion;

  SceneModel({
    required this.id,
    required this.name,
    required this.environment,
    this.camera = 'wide',
    this.motion = 'none',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'environment': environment,
        'camera': camera,
        'motion': motion,
      };

  factory SceneModel.fromJson(Map<String, dynamic> json) {
    return SceneModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      environment: (json['environment'] ?? '').toString(),
      camera: (json['camera'] ?? 'wide').toString(),
      motion: (json['motion'] ?? 'none').toString(),
    );
  }
}
