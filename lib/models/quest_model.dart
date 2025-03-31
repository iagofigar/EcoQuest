class Quest {
  final int id;
  String? name;
  String? description;
  int? reward;

  Quest({required this.id, this.name, this.description, this.reward});

  factory Quest.fromMap(Map<String, dynamic> map) {
    return Quest(
      id: map['id'] as int,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      reward: map['reward'] as int,
    );
  }
}