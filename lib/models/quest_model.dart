class Quest {
  final int id;
  String? name;
  String? description;
  int? reward;
  //int? progress;

  Quest({required this.id, this.name, this.description, this.reward});

  factory Quest.fromMap(dynamic id, Map<String, dynamic> map) {
    return Quest(
      id: id as int,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      reward: map['reward'] as int,
      //progress: map['progress'] as int,
    );
  }
}