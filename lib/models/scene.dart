class SceneModel {
  final String id;
  final String name;
  final String environment;
  final String camera;
  final String motion;

  SceneModel({
    required this.id,
    required this.name,
    this.environment = 'room',
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

  factory SceneModel.fromJson(Map<String, dynamic> json) => SceneModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        environment: json['environment'] ?? 'room',
        camera: json['camera'] ?? 'wide',
        motion: json['motion'] ?? 'none',
      );
}
