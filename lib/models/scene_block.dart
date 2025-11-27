class SceneBlock {
  String name;
  String environment;
  String camera;
  String motion;
  SceneBlock({required this.name, this.environment = 'Room', this.camera = 'Mid-shot', this.motion = 'Smooth'});

  Map<String, dynamic> toJson() => {'name': name, 'env': environment, 'camera': camera, 'motion': motion};
  factory SceneBlock.fromJson(Map<String, dynamic> j) => SceneBlock(name: j['name'] ?? 'Scene', environment: j['env'] ?? 'Room', camera: j['camera'] ?? 'Mid-shot', motion: j['motion'] ?? 'Smooth');
}
