class SceneModel {
  String camera;
  String environment;

  SceneModel({
    required this.camera,
    required this.environment,
  });

  Map<String, dynamic> toJson() => {
        "camera": camera,
        "environment": environment,
      };
}
