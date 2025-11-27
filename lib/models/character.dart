// lib/models/character.dart
class CharacterModel {
  String name;
  String voice;
  String outfit;
  Map<String, dynamic> extra;

  CharacterModel({
    required this.name,
    this.voice = 'Narrator',
    this.outfit = 'Default',
    Map<String, dynamic>? extra,
  }) : extra = extra ?? {};

  factory CharacterModel.fromJson(Map<String, dynamic> j) {
    return CharacterModel(
      name: j['name'] ?? '',
      voice: j['voice'] ?? 'Narrator',
      outfit: j['outfit'] ?? 'Default',
      extra: Map<String, dynamic>.from(j['extra'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'voice': voice,
        'outfit': outfit,
        'extra': extra,
      };
}
