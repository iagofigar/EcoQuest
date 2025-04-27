class Quest {
  final int id;
  final String? name;
  final String? description;
  final int? reward;
  final bool isCompleted;

  Quest({
    required this.id,
    this.name,
    this.description,
    this.reward,
    this.isCompleted = false,
  });

  factory Quest.fromMap(dynamic id, Map<String, dynamic> map, [bool isCompleted = false]) {
    return Quest(
      id: id as int,
      name: map['name'] as String?,
      description: map['description'] as String?,
      reward: map['reward'] as int?,
      isCompleted: isCompleted,
    );
  }
}