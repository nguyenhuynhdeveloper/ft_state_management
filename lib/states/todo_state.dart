// File định nghĩa tất cả các States cho TodoBloc
// States đại diện cho trạng thái hiện tại của ứng dụng
import 'package:equatable/equatable.dart';
import '../models/todo.dart';

// Base class cho tất cả TodoStates
// Sử dụng Equatable để BLoC có thể so sánh states và quyết định rebuild widget
abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object?> get props => [];
}

// State: Trạng thái khởi tạo ban đầu
class TodoInitial extends TodoState {
  const TodoInitial();
}

// State: Đang load dữ liệu
class TodoLoading extends TodoState {
  const TodoLoading();
}

// State: Load thành công, chứa danh sách todos
class TodoLoaded extends TodoState {
  final List<Todo> todos;

  const TodoLoaded(this.todos);

  @override
  List<Object?> get props => [todos];
}

// State: Có lỗi xảy ra
class TodoError extends TodoState {
  final String message;

  const TodoError(this.message);

  @override
  List<Object?> get props => [message];
}

// State: Đang thực hiện một operation (add, update, delete...)
// Kế thừa từ TodoLoaded để vẫn hiển thị danh sách todos trong khi xử lý
class TodoOperationInProgress extends TodoLoaded {
  const TodoOperationInProgress(super.todos);
}

// State: Operation thành công
class TodoOperationSuccess extends TodoLoaded {
  final String message;

  const TodoOperationSuccess(super.todos, this.message);

  @override
  List<Object?> get props => [todos, message];
}
