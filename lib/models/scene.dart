class SceneModel {
  String name;
  String environment;
  String camera;
  String motion;

  SceneModel({required this.name, this.environment = 'room', this.camera = 'wide', this.motion = 'none'});

  factory SceneModel.fromJson(Map<String, dynamic> json) => SceneModel(
    name: json['name'] ?? '',
    environment: json['environment'] ?? 'room',
    camera: json['camera'] ?? 'wide',
    motion: json['motion'] ?? 'none',
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'environment': environment,
    'camera': camera,
    'motion': motion,
  };
}
