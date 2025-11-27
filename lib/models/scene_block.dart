// lib/models/scene_block.dart
class SceneBlock {
  String environment;
  String camera;
  String motion;
  String name;

  SceneBlock({
    required this.name,
    this.environment = 'room',
    this.camera = 'wide',
    this.motion = 'static',
  });

  factory SceneBlock.fromJson(Map<String, dynamic> j) {
    return SceneBlock(
      name: j['name'] ?? '',
      environment: j['environment'] ?? 'room',
      camera: j['camera'] ?? 'wide',
      motion: j['motion'] ?? 'static',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'environment': environment,
        'camera': camera,
        'motion': motion,
      };
}
