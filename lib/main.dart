// Main entry point của ứng dụng
// Demo cách setup BlocObserver và MultiBlocProvider

import 'package:demo_ft_bloc/events/todo_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/simple_bloc_observer.dart';
import 'blocs/todo_bloc.dart';
import 'blocs/filter_bloc.dart';
import 'blocs/search_bloc.dart';
import 'blocs/filtered_todos_bloc.dart';
import 'repositories/todo_repository.dart';
import 'screens/home_screen.dart';

void main() {
  // Setup BlocObserver để log tất cả BLoC activities
  // Phải được set trước khi tạo bất kỳ BLoC nào
  Bloc.observer = SimpleBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Tạo repository instance
    final todoRepository = TodoRepository();

    return MaterialApp(
      title: 'BLoC Pattern Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // MultiBlocProvider: Cung cấp nhiều BLoCs cho widget tree
      // Tất cả widgets con có thể access các BLoCs này thông qua context
      home: MultiBlocProvider(
        providers: [
          // Provider cho TodoBloc với dependency injection (repository)
          BlocProvider(
            create: (context) {
              final bloc = TodoBloc(repository: todoRepository);
              bloc.add(
                  const TodoLoadRequested()); // Load todos ngay khi khởi tạo
              return bloc;
            },
          ),

          // Provider cho FilterBloc
          BlocProvider(
            create: (context) => FilterBloc(),
          ),

          // Provider cho SearchBloc
          BlocProvider(
            create: (context) => SearchBloc(),
          ),

          // Provider cho FilteredTodosBloc
          // FilteredTodosBloc phụ thuộc vào 3 BLoCs khác
          // Sử dụng context.read() để lấy instance của các BLoCs đã được provide
          BlocProvider(
            create: (context) => FilteredTodosBloc(
              todoBloc: context.read<TodoBloc>(),
              filterBloc: context.read<FilterBloc>(),
              searchBloc: context.read<SearchBloc>(),
            ),
          ),
        ],
        child: const HomeScreen(),
      ),
    );
  }
}
