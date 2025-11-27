class SceneModel {
  String name;
  String environment;
  String camera;
  String motion;

  SceneModel({
    required this.name,
    required this.environment,
    required this.camera,
    required this.motion,
  });

  factory SceneModel.fromJson(Map<String, dynamic> json) {
    return SceneModel(
      name: json['name'] ?? '',
      environment: json['environment'] ?? '',
      camera: json['camera'] ?? '',
      motion: json['motion'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "environment": environment,
      "camera": camera,
      "motion": motion,
    };
  }
}
