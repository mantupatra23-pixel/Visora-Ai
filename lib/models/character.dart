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

  factory CharacterModel.fromJson(Map<String, dynamic> json) => CharacterModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        voice: json['voice'] ?? '',
        outfit: json['outfit'] ?? '',
      );
}
