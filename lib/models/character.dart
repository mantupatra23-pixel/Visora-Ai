class Character {
  String name;
  String voice;
  String outfit;
  Character({required this.name, this.voice = 'Neutral', this.outfit = 'Default'});

  Map<String, dynamic> toJson() => { 'name': name, 'voice': voice, 'outfit': outfit };
  factory Character.fromJson(Map<String, dynamic> j) => Character(name: j['name'] ?? 'Char', voice: j['voice'] ?? 'Neutral', outfit: j['outfit'] ?? 'Default');
}
