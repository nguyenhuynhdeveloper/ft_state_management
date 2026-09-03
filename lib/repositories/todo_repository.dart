// Repository chịu trách nhiệm xử lý data layer
// Trong ví dụ này, data được lưu trong memory, có thể mở rộng để lưu vào database
import '../models/todo.dart';

class TodoRepository {
  // Giả lập database trong memory
  final List<Todo> _todos = [];
  
  // Delay để giả lập async operation (network request, database query...)
  final Duration _delay = const Duration(seconds: 1);

  // Lấy tất cả todos
  Future<List<Todo>> getTodos() async {
    // Giả lập network delay
    await Future.delayed(_delay);
    return List.unmodifiable(_todos);
  }

  // Thêm todo mới
  Future<Todo> addTodo(Todo todo) async {
    await Future.delayed(_delay);
    _todos.add(todo);
    return todo;
  }

  // Cập nhật todo
  Future<Todo> updateTodo(Todo todo) async {
    await Future.delayed(_delay);
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index == -1) {
      throw Exception('Todo không tồn tại');
    }
    _todos[index] = todo;
    return todo;
  }

  // Xóa todo
  Future<void> deleteTodo(String id) async {
    await Future.delayed(_delay);
    _todos.removeWhere((todo) => todo.id == id);
  }

  // Toggle trạng thái completed của todo
  Future<Todo> toggleTodo(String id) async {
    await Future.delayed(_delay);
    final index = _todos.indexWhere((t) => t.id == id);
    if (index == -1) {
      throw Exception('Todo không tồn tại');
    }
    final todo = _todos[index];
    final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
    _todos[index] = updatedTodo;
    return updatedTodo;
  }

  // Xóa tất cả todos đã hoàn thành
  Future<void> clearCompleted() async {
    await Future.delayed(_delay);
    _todos.removeWhere((todo) => todo.isCompleted);
  }
}
