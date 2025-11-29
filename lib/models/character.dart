class CharacterModel {
  final String id;
  final String name;
  final String voice;
  final String outfit;

  CharacterModel({
    required this.id,
    required this.name,
    required this.voice,
    required this.outfit,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'voice': voice,
        'outfit': outfit,
      };

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      voice: (json['voice'] ?? '').toString(),
      outfit: (json['outfit'] ?? '').toString(),
    );
  }
}
