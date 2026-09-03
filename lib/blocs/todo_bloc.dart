// TodoBloc - BLoC chính quản lý danh sách todos
// Demo đầy đủ các tính năng của BLoC pattern

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import '../events/todo_event.dart';
import '../states/todo_state.dart';
import '../repositories/todo_repository.dart';
import '../models/todo.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;

  // Constructor: Inject repository dependency vào BLoC
  // Initial state là TodoInitial
  TodoBloc({required this.repository}) : super(const TodoInitial()) {
    // Đăng ký các event handlers
    // Mỗi event sẽ có một handler tương ứng
    
    // Handler cho TodoLoadRequested
    // Sử dụng restartable transformer: nếu event mới được gửi trong khi đang xử lý,
    // cancel operation cũ và bắt đầu operation mới
    on<TodoLoadRequested>(
      _onLoadRequested,
      transformer: restartable(),
    );

    // Handler cho TodoAdded
    on<TodoAdded>(_onTodoAdded);

    // Handler cho TodoUpdated
    on<TodoUpdated>(_onTodoUpdated);

    // Handler cho TodoDeleted
    on<TodoDeleted>(_onTodoDeleted);

    // Handler cho TodoToggled
    on<TodoToggled>(_onTodoToggled);

    // Handler cho TodoClearCompleted
    on<TodoClearCompleted>(_onClearCompleted);

    // Handler cho TodoToggleAll
    on<TodoToggleAll>(_onToggleAll);
  }

  // Handler: Load todos từ repository
  Future<void> _onLoadRequested(
    TodoLoadRequested event,
    Emitter<TodoState> emit,
  ) async {
    // Emit loading state
    emit(const TodoLoading());

    try {
      // Gọi repository để lấy dữ liệu
      final todos = await repository.getTodos();
      
      // Emit success state với dữ liệu
      emit(TodoLoaded(todos));
    } catch (error) {
      // Emit error state nếu có lỗi
      emit(TodoError(error.toString()));
    }
  }

  // Handler: Thêm todo mới
  Future<void> _onTodoAdded(
    TodoAdded event,
    Emitter<TodoState> emit,
  ) async {
    // Chỉ xử lý khi state hiện tại là TodoLoaded
    if (state is! TodoLoaded) return;

    final currentState = state as TodoLoaded;
    
    // Emit operation in progress
    emit(TodoOperationInProgress(currentState.todos));

    try {
      // Tạo todo mới
      final newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: event.title,
        description: event.description,
        createdAt: DateTime.now(),
      );

      // Thêm vào repository
      await repository.addTodo(newTodo);

      // Lấy lại danh sách todos mới
      final updatedTodos = await repository.getTodos();

      // Emit success state
      emit(TodoOperationSuccess(updatedTodos, 'Thêm todo thành công'));
    } catch (error) {
      // Emit error state, nhưng vẫn giữ danh sách todos hiện tại
      emit(TodoError(error.toString()));
      emit(TodoLoaded(currentState.todos));
    }
  }

  // Handler: Cập nhật todo
  Future<void> _onTodoUpdated(
    TodoUpdated event,
    Emitter<TodoState> emit,
  ) async {
    if (state is! TodoLoaded) return;

    final currentState = state as TodoLoaded;
    emit(TodoOperationInProgress(currentState.todos));

    try {
      await repository.updateTodo(event.todo);
      final updatedTodos = await repository.getTodos();
      emit(TodoOperationSuccess(updatedTodos, 'Cập nhật todo thành công'));
    } catch (error) {
      emit(TodoError(error.toString()));
      emit(TodoLoaded(currentState.todos));
    }
  }

  // Handler: Xóa todo
  Future<void> _onTodoDeleted(
    TodoDeleted event,
    Emitter<TodoState> emit,
  ) async {
    if (state is! TodoLoaded) return;

    final currentState = state as TodoLoaded;
    emit(TodoOperationInProgress(currentState.todos));

    try {
      await repository.deleteTodo(event.todoId);
      final updatedTodos = await repository.getTodos();
      emit(TodoOperationSuccess(updatedTodos, 'Xóa todo thành công'));
    } catch (error) {
      emit(TodoError(error.toString()));
      emit(TodoLoaded(currentState.todos));
    }
  }

  // Handler: Toggle trạng thái todo
  Future<void> _onTodoToggled(
    TodoToggled event,
    Emitter<TodoState> emit,
  ) async {
    if (state is! TodoLoaded) return;

    final currentState = state as TodoLoaded;

    try {
      await repository.toggleTodo(event.todoId);
      final updatedTodos = await repository.getTodos();
      
      // Không cần hiển thị success message cho toggle
      emit(TodoLoaded(updatedTodos));
    } catch (error) {
      emit(TodoError(error.toString()));
      emit(TodoLoaded(currentState.todos));
    }
  }

  // Handler: Xóa tất cả todos đã hoàn thành
  Future<void> _onClearCompleted(
    TodoClearCompleted event,
    Emitter<TodoState> emit,
  ) async {
    if (state is! TodoLoaded) return;

    final currentState = state as TodoLoaded;
    emit(TodoOperationInProgress(currentState.todos));

    try {
      await repository.clearCompleted();
      final updatedTodos = await repository.getTodos();
      emit(TodoOperationSuccess(updatedTodos, 'Đã xóa todos hoàn thành'));
    } catch (error) {
      emit(TodoError(error.toString()));
      emit(TodoLoaded(currentState.todos));
    }
  }

  // Handler: Toggle tất cả todos
  Future<void> _onToggleAll(
    TodoToggleAll event,
    Emitter<TodoState> emit,
  ) async {
    if (state is! TodoLoaded) return;

    final currentState = state as TodoLoaded;
    emit(TodoOperationInProgress(currentState.todos));

    try {
      final todos = currentState.todos;
      
      // Kiểm tra xem tất cả todos đã completed chưa
      final allCompleted = todos.every((todo) => todo.isCompleted);
      
      // Toggle tất cả todos
      for (final todo in todos) {
        if (allCompleted) {
          // Nếu tất cả đã completed, uncomplete tất cả
          if (todo.isCompleted) {
            await repository.toggleTodo(todo.id);
          }
        } else {
          // Nếu chưa, complete tất cả
          if (!todo.isCompleted) {
            await repository.toggleTodo(todo.id);
          }
        }
      }

      final updatedTodos = await repository.getTodos();
      emit(TodoLoaded(updatedTodos));
    } catch (error) {
      emit(TodoError(error.toString()));
      emit(TodoLoaded(currentState.todos));
    }
  }
}
