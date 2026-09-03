// HomeScreen - Màn hình chính của ứng dụng
// Demo: BlocBuilder, BlocListener, BlocConsumer, context.read(), context.watch()

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/todo_bloc.dart';
import '../blocs/filter_bloc.dart';
import '../blocs/search_bloc.dart';
import '../blocs/filtered_todos_bloc.dart';
import '../events/todo_event.dart';
import '../events/filter_event.dart';
import '../events/search_event.dart';
import '../states/todo_state.dart';
import '../states/filter_state.dart';
import '../states/search_state.dart';
import '../models/todo_filter.dart';
import 'add_todo_screen.dart';
import 'edit_todo_screen.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLoC Pattern Demo'),
        elevation: 2,
        actions: [
          // Demo context.read() - Đọc BLoC mà không listen changes
          // Dùng để dispatch events hoặc call methods
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              // Capture BLoC TRƯỚC khi navigate (context bên ngoài có access)
              final todoBloc = context.read<TodoBloc>();
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (newContext) => BlocProvider.value(
                    value: todoBloc,  // Dùng captured BLoC
                    child: const StatisticsScreen(),
                  ),
                ),
              );
            },
            tooltip: 'Statistics',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Dispatch event để reload todos
              context.read<TodoBloc>().add(const TodoLoadRequested());
            },
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              // Dispatch event để xóa todos đã hoàn thành
              context.read<TodoBloc>().add(const TodoClearCompleted());
            },
            tooltip: 'Clear Completed',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          _buildSearchBar(),
          
          // Filter chips
          _buildFilterChips(),
          
          // Statistics
          _buildStatistics(),
          
          // Todo list
          const Expanded(
            child: _TodoList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Capture BLoC TRƯỚC khi navigate (context bên ngoài có access)
          final todoBloc = context.read<TodoBloc>();
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (newContext) => BlocProvider.value(
                value: todoBloc,  // Dùng captured BLoC
                child: const AddTodoScreen(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Widget: Search bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      // Demo BlocBuilder - Rebuild widget khi state thay đổi
      // BlocBuilder lắng nghe SearchBloc và rebuild khi SearchState thay đổi
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return TextField(
            decoration: InputDecoration(
              hintText: 'Tìm kiếm todo...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: state.query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        // Dispatch event để clear search
                        context.read<SearchBloc>().add(
                          const SearchQueryCleared(),
                        );
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              // Dispatch event khi user gõ
              // SearchBloc sẽ debounce và chỉ xử lý sau 300ms
              context.read<SearchBloc>().add(
                SearchQueryChanged(value),
              );
            },
          );
        },
      ),
    );
  }

  // Widget: Filter chips
  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      // Demo BlocBuilder với FilterBloc
      child: BlocBuilder<FilterBloc, FilterState>(
        builder: (context, state) {
          return Row(
            children: [
              const Text('Filter: '),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                'All',
                TodoFilter.all,
                state.filter == TodoFilter.all,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                'Active',
                TodoFilter.active,
                state.filter == TodoFilter.active,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                'Completed',
                TodoFilter.completed,
                state.filter == TodoFilter.completed,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    TodoFilter filter,
    bool isSelected,
  ) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          // Dispatch event để thay đổi filter
          context.read<FilterBloc>().add(FilterChanged(filter));
        }
      },
    );
  }

  // Widget: Statistics
  Widget _buildStatistics() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      // Demo BlocBuilder với FilteredTodosBloc
      child: BlocBuilder<FilteredTodosBloc, FilteredTodosState>(
        builder: (context, state) {
          if (state is FilteredTodosLoaded) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      'Tổng',
                      '${state.activeCount + state.completedCount}',
                      Colors.blue,
                    ),
                    _buildStatItem(
                      'Chưa hoàn thành',
                      '${state.activeCount}',
                      Colors.orange,
                    ),
                    _buildStatItem(
                      'Đã hoàn thành',
                      '${state.completedCount}',
                      Colors.green,
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

// Widget riêng cho Todo List
// Demo: BlocListener, BlocConsumer
class _TodoList extends StatelessWidget {
  const _TodoList();

  @override
  Widget build(BuildContext context) {
    // Demo BlocListener - Lắng nghe state changes để thực hiện side effects
    // BlocListener KHÔNG rebuild widget, chỉ dùng để show snackbar, navigate, etc.
    return BlocListener<TodoBloc, TodoState>(
      // listener được gọi mỗi khi TodoState thay đổi
      listener: (context, state) {
        // Show snackbar khi có TodoOperationSuccess
        if (state is TodoOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
        
        // Show error snackbar khi có TodoError
        if (state is TodoError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      // Child là BlocBuilder để build UI dựa trên state
      child: BlocBuilder<FilteredTodosBloc, FilteredTodosState>(
        builder: (context, filteredState) {
          if (filteredState is FilteredTodosLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (filteredState is FilteredTodosLoaded) {
            final todos = filteredState.filteredTodos;

            if (todos.isEmpty) {
              return const Center(
                child: Text(
                  'Không có todo nào',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            // Demo: Show loading overlay khi đang thực hiện operation
            return BlocBuilder<TodoBloc, TodoState>(
              builder: (context, todoState) {
                return Stack(
                  children: [
                    ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        return _TodoItem(todo: todo);
                      },
                    ),
                    // Show loading overlay
                    if (todoState is TodoOperationInProgress)
                      Container(
                        color: Colors.black.withOpacity(0.3),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// Widget riêng cho Todo Item
class _TodoItem extends StatelessWidget {
  final dynamic todo;

  const _TodoItem({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (value) {
            // Dispatch event để toggle todo
            context.read<TodoBloc>().add(TodoToggled(todo.id));
          },
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted 
                ? TextDecoration.lineThrough 
                : null,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          todo.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            decoration: todo.isCompleted 
                ? TextDecoration.lineThrough 
                : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                // Capture BLoC TRƯỚC khi navigate
                final todoBloc = context.read<TodoBloc>();
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (newContext) => BlocProvider.value(
                      value: todoBloc,  // Dùng captured BLoC
                      child: EditTodoScreen(todo: todo),
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Show confirmation dialog
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Xác nhận'),
                    content: const Text('Bạn có chắc muốn xóa todo này?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text('Hủy'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Dispatch event để xóa todo
                          context.read<TodoBloc>().add(
                            TodoDeleted(todo.id),
                          );
                          Navigator.pop(dialogContext);
                        },
                        child: const Text(
                          'Xóa',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
