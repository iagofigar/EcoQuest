class PuntVerd {
  final String name;
  final double x;
  final double y;
  final String address;

  PuntVerd({
    required this.name,
    required this.x,
    required this.y,
    required this.address,
  });

  // Factory method to create a PuntVerd from a map (e.g., from JSON)
  factory PuntVerd.fromMap(Map<String, dynamic> map) {
    return PuntVerd(
      name: map['name'],
      x: map['x'],
      y: map['y'],
      address: map['address']
    );
  }
}