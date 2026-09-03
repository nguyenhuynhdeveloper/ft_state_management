// FilteredTodosBloc - BLoC kết hợp TodoBloc, FilterBloc và SearchBloc
// Demo cách một BLoC lắng nghe và phản ứng với nhiều BLoCs khác

import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/todo.dart';
import '../models/todo_filter.dart';
import '../blocs/todo_bloc.dart';
import '../blocs/filter_bloc.dart';
import '../blocs/search_bloc.dart';
import '../states/todo_state.dart';
import '../states/filter_state.dart';
import '../states/search_state.dart';

// Events cho FilteredTodosBloc
abstract class FilteredTodosEvent {}

// Event được trigger khi TodoBloc, FilterBloc hoặc SearchBloc thay đổi
class FilteredTodosUpdated extends FilteredTodosEvent {
  final List<Todo> todos;
  final TodoFilter filter;
  final String searchQuery;

  FilteredTodosUpdated({
    required this.todos,
    required this.filter,
    required this.searchQuery,
  });
}

// States cho FilteredTodosBloc
abstract class FilteredTodosState {
  const FilteredTodosState();
}

class FilteredTodosLoading extends FilteredTodosState {
  const FilteredTodosLoading();
}

class FilteredTodosLoaded extends FilteredTodosState {
  final List<Todo> filteredTodos;
  final int activeCount;
  final int completedCount;

  const FilteredTodosLoaded({
    required this.filteredTodos,
    required this.activeCount,
    required this.completedCount,
  });
}

// FilteredTodosBloc lắng nghe 3 BLoCs khác
class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  final TodoBloc todoBloc;
  final FilterBloc filterBloc;
  final SearchBloc searchBloc;

  FilteredTodosBloc({
    required this.todoBloc,
    required this.filterBloc,
    required this.searchBloc,
  }) : super(const FilteredTodosLoading()) {
    // Handler cho FilteredTodosUpdated
    on<FilteredTodosUpdated>(_onFilteredTodosUpdated);

    // Lắng nghe TodoBloc và trigger event khi có thay đổi
    // Đây là cách BLoC có thể phản ứng với BLoC khác
    todoBloc.stream.listen((todoState) {
      if (todoState is TodoLoaded) {
        add(FilteredTodosUpdated(
          todos: todoState.todos,
          filter: filterBloc.state.filter,
          searchQuery: searchBloc.state.query,
        ));
      }
    });

    // Lắng nghe FilterBloc
    filterBloc.stream.listen((filterState) {
      final todoState = todoBloc.state;
      if (todoState is TodoLoaded) {
        add(FilteredTodosUpdated(
          todos: todoState.todos,
          filter: filterState.filter,
          searchQuery: searchBloc.state.query,
        ));
      }
    });

    // Lắng nghe SearchBloc
    searchBloc.stream.listen((searchState) {
      final todoState = todoBloc.state;
      if (todoState is TodoLoaded) {
        add(FilteredTodosUpdated(
          todos: todoState.todos,
          filter: filterBloc.state.filter,
          searchQuery: searchState.query,
        ));
      }
    });
  }

  // Handler: Xử lý filtering và searching
  void _onFilteredTodosUpdated(
    FilteredTodosUpdated event,
    Emitter<FilteredTodosState> emit,
  ) {
    // Bước 1: Filter theo filter type (all, active, completed)
    List<Todo> filteredTodos = event.todos;

    switch (event.filter) {
      case TodoFilter.active:
        filteredTodos = filteredTodos.where((todo) => !todo.isCompleted).toList();
        break;
      case TodoFilter.completed:
        filteredTodos = filteredTodos.where((todo) => todo.isCompleted).toList();
        break;
      case TodoFilter.all:
        // Không cần filter
        break;
    }

    // Bước 2: Filter theo search query
    if (event.searchQuery.isNotEmpty) {
      final query = event.searchQuery.toLowerCase();
      filteredTodos = filteredTodos.where((todo) {
        return todo.title.toLowerCase().contains(query) ||
            todo.description.toLowerCase().contains(query);
      }).toList();
    }

    // Tính toán statistics
    final activeCount = event.todos.where((todo) => !todo.isCompleted).length;
    final completedCount = event.todos.where((todo) => todo.isCompleted).length;

    // Emit state với filtered todos
    emit(FilteredTodosLoaded(
      filteredTodos: filteredTodos,
      activeCount: activeCount,
      completedCount: completedCount,
    ));
  }
}
