// Model đại diện cho một Todo item
// Sử dụng Equatable để so sánh các instance dễ dàng hơn trong BLoC
import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;

  const Todo({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
  });

  // CopyWith method để tạo bản sao với các thuộc tính được cập nhật
  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Equatable giúp so sánh các instance dựa trên các thuộc tính
  // thay vì reference, rất quan trọng cho việc rebuild widget trong BLoC
  @override
  List<Object?> get props => [id, title, description, isCompleted, createdAt];
}
