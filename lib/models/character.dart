class CharacterModel {
  String id;
  String name;
  String voice;
  String outfit;

  CharacterModel({required this.id, required this.name, this.voice = 'default', this.outfit = 'none'});

  factory CharacterModel.fromJson(Map<String, dynamic> json) => CharacterModel(
    id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
    name: json['name'] ?? '',
    voice: json['voice'] ?? 'default',
    outfit: json['outfit'] ?? 'none',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'voice': voice,
    'outfit': outfit,
  };
}
