// lib/models/scene.dart
import 'scene_block.dart';

class SceneModel {
  String name;
  String environment;
  String camera;
  String motion;
  List<SceneBlock> blocks;

  SceneModel({
    required this.name,
    this.environment = 'room',
    this.camera = 'wide',
    this.motion = 'static',
    List<SceneBlock>? blocks,
  }) : blocks = blocks ?? [];

  factory SceneModel.fromJson(Map<String, dynamic> j) {
    final blocksList = (j['blocks'] as List<dynamic>?)
            ?.map((e) => SceneBlock.fromJson(Map<String, dynamic>.from(e)))
            .toList() ??
        [];
    return SceneModel(
      name: j['name'] ?? '',
      environment: j['environment'] ?? 'room',
      camera: j['camera'] ?? 'wide',
      motion: j['motion'] ?? 'static',
      blocks: blocksList,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'environment': environment,
        'camera': camera,
        'motion': motion,
        'blocks': blocks.map((b) => b.toJson()).toList(),
      };
}
