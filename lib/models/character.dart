class CharacterModel {
  String id;
  String name;
  String voice;
  String outfit;

  CharacterModel({
    required this.id,
    required this.name,
    required this.voice,
    required this.outfit,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> j) {
    return CharacterModel(
      id: j['id'].toString(),
      name: j['name'] ?? '',
      voice: j['voice'] ?? '',
      outfit: j['outfit'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'voice': voice,
        'outfit': outfit,
      };
}
