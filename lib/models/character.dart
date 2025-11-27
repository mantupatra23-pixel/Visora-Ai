// lib/models/character.dart
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

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      voice: json['voice']?.toString() ?? 'default',
      outfit: json['outfit']?.toString() ?? 'default',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'voice': voice,
      'outfit': outfit,
    };
  }

  @override
  String toString() => 'CharacterModel(id: $id, name: $name)';
}
