// File định nghĩa tất cả các Events cho TodoBloc
// Events là các hành động mà UI gửi đến BLoC để yêu cầu xử lý
import 'package:equatable/equatable.dart';
import '../models/todo.dart';

// Base class cho tất cả TodoEvents
// Sử dụng Equatable để BLoC có thể so sánh các events
abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

// Event: Load danh sách todos từ repository
class TodoLoadRequested extends TodoEvent {
  const TodoLoadRequested();
}

// Event: Thêm todo mới
class TodoAdded extends TodoEvent {
  final String title;
  final String description;

  const TodoAdded({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description];
}

// Event: Cập nhật todo hiện có
class TodoUpdated extends TodoEvent {
  final Todo todo;

  const TodoUpdated(this.todo);

  @override
  List<Object?> get props => [todo];
}

// Event: Xóa todo
class TodoDeleted extends TodoEvent {
  final String todoId;

  const TodoDeleted(this.todoId);

  @override
  List<Object?> get props => [todoId];
}

// Event: Toggle trạng thái completed của todo
class TodoToggled extends TodoEvent {
  final String todoId;

  const TodoToggled(this.todoId);

  @override
  List<Object?> get props => [todoId];
}

// Event: Xóa tất cả todos đã hoàn thành
class TodoClearCompleted extends TodoEvent {
  const TodoClearCompleted();
}

// Event: Toggle tất cả todos (complete hoặc uncomplete all)
class TodoToggleAll extends TodoEvent {
  const TodoToggleAll();
}
