import 'package:flutter/foundation.dart' show immutable;
import 'package:riverpod/riverpod.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

// Tạo 1 class của đối tượng việc cần làm có các property description , is, completed 
@immutable
class Todo {
  const Todo({
    required this.description,
    required this.id,
    this.completed = false,
  });

  final String id;
  final String description;
  final bool completed;

  @override
  String toString() {
    return 'Todo(description: $description, completed: $completed)';
  }
}

// Tạo 1 class Todo List extends Notifier Để có thể làm state cho NotifierProvider 
// Tại class này định nghĩa các hàm sẵn để thay đổi gía trị của State trong Provider 
class TodoList extends Notifier<List<Todo>> {
  @override
  List<Todo> build() => [
        const Todo(id: 'todo-0', description: 'Buy cookies'),
        const Todo(id: 'todo-1', description: 'Star Riverpod'),
        const Todo(id: 'todo-2', description: 'Have a walk'),
      ];

// Thêm việc làm vào danh sáchh việc làm 
  void add(String description) {
    state = [
      ...state,
      Todo(
        id: _uuid.v4(),
        description: description,
      ),
    ];
  }

// Thay đổi giá trị completed của việc làm 
  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: !todo.completed,
            description: todo.description,
          )
        else
          todo,
    ];
  }

// Sửa đổi giá trị của Việc làm 
  void edit({required String id, required String description}) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: todo.completed,
            description: description,
          )
        else
          todo,
    ];
  }

// Xoá 1 việc làm khỏi danh sách
  void remove(Todo target) {
    state = state.where((todo) => todo.id != target.id).toList();
  }
}
