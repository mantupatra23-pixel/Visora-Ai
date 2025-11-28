import 'scene_block.dart';

class SceneModel {
  String id;
  String name;
  String environment;
  List<SceneBlock> blocks;

  SceneModel({
    required this.id,
    required this.name,
    required this.environment,
    required this.blocks,
  });

  factory SceneModel.fromJson(Map<String, dynamic> j) {
    final blocksJson = (j['blocks'] as List? ?? []);
    return SceneModel(
      id: j['id'].toString(),
      name: j['name'] ?? '',
      environment: j['environment'] ?? '',
      blocks: blocksJson
          .map((e) => SceneBlock.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'environment': environment,
        'blocks': blocks.map((b) => b.toJson()).toList(),
      };
}
