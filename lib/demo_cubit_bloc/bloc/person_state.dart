class PersonState {
  // Cách thuộc tính của class PersonState
  String fullName;
  String position;
  int age;
  // Cách khởi tạo của class PersonState

  PersonState({
    required this.fullName,
    required this.position,
    required this.age,
  });

// Cách copyWith của class PersonState
  copyWith({String? fullName, String? position, int? age}) => PersonState(
      fullName: fullName ?? this.fullName,
      position: position ?? this.position,
      age: age ?? this.age);
}
