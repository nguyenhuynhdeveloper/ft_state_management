// StatisticsScreen - Màn hình thống kê
// Demo: BlocConsumer - kết hợp BlocBuilder và BlocListener

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/todo_bloc.dart';
import '../blocs/filtered_todos_bloc.dart';
import '../states/todo_state.dart';
import '../models/todo.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống Kê'),
        elevation: 2,
      ),
      // Demo BlocConsumer - kết hợp listener và builder
      // BlocConsumer = BlocListener + BlocBuilder trong một widget
      body: BlocConsumer<TodoBloc, TodoState>(
        // Listener: xử lý side effects
        listener: (context, state) {
          if (state is TodoOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is TodoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        // Builder: build UI dựa trên state
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is TodoLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: _buildStatistics(context, state.todos),
            );
          }

          if (state is TodoError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Lỗi: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Không có dữ liệu'),
          );
        },
      ),
    );
  }

  Widget _buildStatistics(BuildContext context, List<Todo> todos) {
    final totalCount = todos.length;
    final completedCount = todos.where((todo) => todo.isCompleted).length;
    final activeCount = totalCount - completedCount;
    final completionRate = totalCount > 0 
        ? (completedCount / totalCount * 100).toStringAsFixed(1) 
        : '0.0';

    return Column(
      children: [
        // Overview card
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Text(
                  'Tổng Quan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      'Tổng Số',
                      totalCount.toString(),
                      Icons.list,
                      Colors.blue,
                    ),
                    _buildStatCard(
                      'Chưa Xong',
                      activeCount.toString(),
                      Icons.radio_button_unchecked,
                      Colors.orange,
                    ),
                    _buildStatCard(
                      'Đã Xong',
                      completedCount.toString(),
                      Icons.check_circle,
                      Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Completion rate card
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Text(
                  'Tỷ Lệ Hoàn Thành',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: totalCount > 0 ? completedCount / totalCount : 0,
                        strokeWidth: 12,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getCompletionColor(
                            totalCount > 0 ? completedCount / totalCount : 0,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          '$completionRate%',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Recent todos
        if (todos.isNotEmpty) ...[
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Todos Gần Đây',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...todos.take(5).map((todo) => ListTile(
                    leading: Icon(
                      todo.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: todo.isCompleted ? Colors.green : Colors.orange,
                    ),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Text(
                      _formatDate(todo.createdAt),
                      style: const TextStyle(fontSize: 12),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 40, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Color _getCompletionColor(double rate) {
    if (rate >= 0.8) return Colors.green;
    if (rate >= 0.5) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
