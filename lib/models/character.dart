class CharacterModel {
  String name;
  String outfit;

  CharacterModel({
    required this.name,
    required this.outfit,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "outfit": outfit,
      };
}
