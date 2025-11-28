// lib/models/character.dart
class CharacterModel {
  final String id;
  final String name;
  final String voice; // e.g. male, female, kid
  final String outfit; // outfit preset name

  CharacterModel({
    required this.id,
    required this.name,
    required this.voice,
    required this.outfit,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'voice': voice,
      'outfit': outfit,
    };
  }

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      voice: json['voice']?.toString() ?? '',
      outfit: json['outfit']?.toString() ?? '',
    );
  }
}
