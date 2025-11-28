// lib/models/scene.dart
class SceneModel {
  final String id;
  final String name;
  final String environment; // e.g. room, road, forest
  final String camera; // e.g. wide, closeup
  final String motion; // e.g. smooth, pan

  SceneModel({
    required this.id,
    required this.name,
    required this.environment,
    required this.camera,
    required this.motion,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'environment': environment,
      'camera': camera,
      'motion': motion,
    };
  }

  factory SceneModel.fromJson(Map<String, dynamic> json) {
    return SceneModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      environment: json['environment']?.toString() ?? '',
      camera: json['camera']?.toString() ?? '',
      motion: json['motion']?.toString() ?? '',
    );
  }
}
