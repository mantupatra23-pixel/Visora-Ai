class SceneModel {
  String environment;
  String camera;
  String motion;

  SceneModel({
    required this.environment,
    required this.camera,
    required this.motion,
  });

  Map<String, dynamic> toJson() => {
        "environment": environment,
        "camera": camera,
        "motion": motion,
      };

  factory SceneModel.fromJson(Map<String, dynamic> json) {
    return SceneModel(
      environment: json["environment"] ?? "",
      camera: json["camera"] ?? "",
      motion: json["motion"] ?? "",
    );
  }
}
