class PersonState {
  String fullName;
  String position;
  int age;
  PersonState({
    required this.fullName,
    required this.position,
    required this.age,
  });



  
  copyWith({String? fullName, String? position, int? age}) => PersonState(
      fullName: fullName ?? this.fullName,
      position: position ?? this.position,
      age: age ?? this.age);
}
