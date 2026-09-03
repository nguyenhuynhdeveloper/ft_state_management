// ============================================
// QUICK REFERENCE - BLOC PATTERN CHEAT SHEET
// ============================================

/*
┌─────────────────────────────────────────────────────────────────┐
│  1. CẤU TRÚC CƠ BẢN                                              │
└─────────────────────────────────────────────────────────────────┘

UI Widget
    ↓ (dispatch event)
  EVENT ────────────→ BLOC ────────────→ STATE
    ↑                  ↓                   ↓
    │                LOGIC              (rebuild)
    │                  ↓                   ↓
    └─────────── REPOSITORY          UI Widget


┌─────────────────────────────────────────────────────────────────┐
│  2. ĐỊNH NGHĨA EVENT                                             │
└─────────────────────────────────────────────────────────────────┘

abstract class TodoEvent extends Equatable {
  const TodoEvent();
  @override
  List<Object?> get props => [];
}

class TodoAdded extends TodoEvent {
  final String title;
  const TodoAdded(this.title);
  @override
  List<Object?> get props => [title];
}


┌─────────────────────────────────────────────────────────────────┐
│  3. ĐỊNH NGHĨA STATE                                             │
└─────────────────────────────────────────────────────────────────┘

abstract class TodoState extends Equatable {
  const TodoState();
  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {}
class TodoLoading extends TodoState {}
class TodoLoaded extends TodoState {
  final List<Todo> todos;
  const TodoLoaded(this.todos);
  @override
  List<Object?> get props => [todos];
}
class TodoError extends TodoState {
  final String message;
  const TodoError(this.message);
  @override
  List<Object?> get props => [message];
}


┌─────────────────────────────────────────────────────────────────┐
│  4. ĐỊNH NGHĨA BLOC                                              │
└─────────────────────────────────────────────────────────────────┘

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;
  
  TodoBloc({required this.repository}) : super(TodoInitial()) {
    on<TodoAdded>(_onTodoAdded);
    on<TodoLoaded>(_onTodoLoaded, transformer: restartable());
  }
  
  Future<void> _onTodoAdded(
    TodoAdded event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());
    try {
      await repository.addTodo(event.title);
      final todos = await repository.getTodos();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }
  
  Future<void> _onTodoLoaded(
    TodoLoaded event,
    Emitter<TodoState> emit,
  ) async {
    // Handler logic
  }
}


┌─────────────────────────────────────────────────────────────────┐
│  5. SETUP TRONG MAIN                                             │
└─────────────────────────────────────────────────────────────────┘

void main() {
  // Setup BlocObserver
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TodoBloc(repository: TodoRepository()),
        ),
        BlocProvider(
          create: (context) => FilterBloc(),
        ),
      ],
      child: MaterialApp(home: HomeScreen()),
    );
  }
}


┌─────────────────────────────────────────────────────────────────┐
│  6. BLOC WIDGETS - CÁCH SỬ DỤNG                                  │
└─────────────────────────────────────────────────────────────────┘

// ─── BlocBuilder ───────────────────────────────────────────────
// Mục đích: Rebuild UI khi state thay đổi
// Khi nào dùng: Khi cần hiển thị data từ state

BlocBuilder<TodoBloc, TodoState>(
  builder: (context, state) {
    if (state is TodoLoading) return CircularProgressIndicator();
    if (state is TodoLoaded) return TodoList(todos: state.todos);
    if (state is TodoError) return Text(state.message);
    return Text('No data');
  },
)


// ─── BlocListener ──────────────────────────────────────────────
// Mục đích: Side effects (snackbar, navigation) KHÔNG rebuild
// Khi nào dùng: Show notification, navigate, log, etc.

BlocListener<TodoBloc, TodoState>(
  listener: (context, state) {
    if (state is TodoError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: ChildWidget(), // Không rebuild
)


// ─── BlocConsumer ──────────────────────────────────────────────
// Mục đích: Kết hợp Builder + Listener
// Khi nào dùng: Cần cả rebuild UI và side effects

BlocConsumer<TodoBloc, TodoState>(
  listener: (context, state) {
    // Side effects
    if (state is TodoError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  builder: (context, state) {
    // Build UI
    if (state is TodoLoaded) return TodoList(todos: state.todos);
    return CircularProgressIndicator();
  },
)


// ─── BlocSelector ──────────────────────────────────────────────
// Mục đích: Rebuild chỉ khi một phần của state thay đổi
// Khi nào dùng: Optimize performance, chỉ quan tâm 1 field

BlocSelector<TodoBloc, TodoState, int>(
  selector: (state) {
    if (state is TodoLoaded) return state.todos.length;
    return 0;
  },
  builder: (context, count) {
    return Text('Total: $count');
  },
)


┌─────────────────────────────────────────────────────────────────┐
│  7. CONTEXT METHODS                                              │
└─────────────────────────────────────────────────────────────────┘

// ─── context.read<T>() ─────────────────────────────────────────
// Mục đích: Lấy BLoC KHÔNG listen changes
// Khi nào dùng: Dispatch events, call methods

ElevatedButton(
  onPressed: () {
    context.read<TodoBloc>().add(TodoAdded('New Todo'));
  },
  child: Text('Add'),
)


// ─── context.watch<T>() ────────────────────────────────────────
// Mục đích: Lấy BLoC VÀ listen changes (widget sẽ rebuild)
// Khi nào dùng: Cần access state và auto rebuild

Widget build(BuildContext context) {
  final state = context.watch<TodoBloc>().state;
  if (state is TodoLoaded) {
    return Text('Count: ${state.todos.length}');
  }
  return Text('Loading...');
}


// ─── context.select<T, R>() ────────────────────────────────────
// Mục đích: Listen chỉ một phần của state
// Khi nào dùng: Optimize performance

Widget build(BuildContext context) {
  final count = context.select<TodoBloc, int>((bloc) {
    final state = bloc.state;
    if (state is TodoLoaded) return state.todos.length;
    return 0;
  });
  return Text('Count: $count');
}


┌─────────────────────────────────────────────────────────────────┐
│  8. STREAM TRANSFORMERS                                          │
└─────────────────────────────────────────────────────────────────┘

import 'package:bloc_concurrency/bloc_concurrency.dart';

// ─── sequential() ──────────────────────────────────────────────
// Xử lý events tuần tự, đợi event trước xong mới xử lý event sau
on<TodoAdded>(_onTodoAdded, transformer: sequential());


// ─── concurrent() ──────────────────────────────────────────────
// Xử lý tất cả events đồng thời
on<TodoAdded>(_onTodoAdded, transformer: concurrent());


// ─── restartable() ─────────────────────────────────────────────
// Cancel operation cũ khi có event mới
on<SearchEvent>(_onSearch, transformer: restartable());


// ─── droppable() ───────────────────────────────────────────────
// Bỏ qua event mới nếu đang xử lý event cũ
on<TodoAdded>(_onTodoAdded, transformer: droppable());


// ─── debounce() ────────────────────────────────────────────────
// Delay xử lý event (chờ user ngừng typing)
on<SearchEvent>(
  _onSearch,
  transformer: debounce(Duration(milliseconds: 300)),
);


┌─────────────────────────────────────────────────────────────────┐
│  9. BLOC OBSERVER                                                │
└─────────────────────────────────────────────────────────────────┘

class SimpleBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('✨ ${bloc.runtimeType} created');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('🎯 ${bloc.runtimeType} $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('📝 ${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('🔄 ${bloc.runtimeType} $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print('❌ ${bloc.runtimeType} $error');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('🔒 ${bloc.runtimeType} closed');
  }
}


┌─────────────────────────────────────────────────────────────────┐
│  10. BLOC COMMUNICATION (BLoC lắng nghe BLoC khác)               │
└─────────────────────────────────────────────────────────────────┘

class FilteredTodosBloc extends Bloc<FilteredEvent, FilteredState> {
  final TodoBloc todoBloc;
  final FilterBloc filterBloc;
  
  FilteredTodosBloc({
    required this.todoBloc,
    required this.filterBloc,
  }) : super(FilteredInitial()) {
    // Listen to TodoBloc changes
    todoBloc.stream.listen((todoState) {
      if (todoState is TodoLoaded) {
        add(UpdateFiltered(
          todos: todoState.todos,
          filter: filterBloc.state.filter,
        ));
      }
    });
    
    // Listen to FilterBloc changes
    filterBloc.stream.listen((filterState) {
      final todoState = todoBloc.state;
      if (todoState is TodoLoaded) {
        add(UpdateFiltered(
          todos: todoState.todos,
          filter: filterState.filter,
        ));
      }
    });
  }
}


┌─────────────────────────────────────────────────────────────────┐
│  11. BEST PRACTICES                                              │
└─────────────────────────────────────────────────────────────────┘

✅ DO:
- Sử dụng Equatable cho Events và States
- Tách repository ra khỏi BLoC (dependency injection)
- Dùng const constructors khi có thể
- Xử lý errors trong try-catch
- Emit Loading state trước khi làm async work
- Dùng meaningful state names (Loading, Loaded, Error)

❌ DON'T:
- Emit cùng state instance (phải tạo state mới)
- Gọi async operations trực tiếp trong UI
- Forget to add events to handlers với on<Event>()
- Mix business logic vào UI widgets
- Ignore error states


┌─────────────────────────────────────────────────────────────────┐
│  12. SO SÁNH KHI NÀO DÙNG GÌ                                     │
└─────────────────────────────────────────────────────────────────┘

┌──────────────────┬─────────────┬──────────────┬──────────────┐
│                  │ BlocBuilder │ BlocListener │ BlocConsumer │
├──────────────────┼─────────────┼──────────────┼──────────────┤
│ Rebuild UI       │     ✅      │      ❌      │      ✅      │
│ Side Effects     │     ❌      │      ✅      │      ✅      │
│ Use Case         │ Show data   │ Notification │     Both     │
└──────────────────┴─────────────┴──────────────┴──────────────┘

┌──────────────────┬──────────────┬──────────────┐
│                  │ context.read │ context.watch│
├──────────────────┼──────────────┼──────────────┤
│ Listen changes   │      ❌      │      ✅      │
│ Rebuild widget   │      ❌      │      ✅      │
│ Use Case         │ Dispatch evt │  Show data   │
└──────────────────┴──────────────┴──────────────┘


┌─────────────────────────────────────────────────────────────────┐
│  13. COMMON PATTERNS                                             │
└─────────────────────────────────────────────────────────────────┘

// Pattern 1: Show loading overlay
BlocBuilder<TodoBloc, TodoState>(
  builder: (context, state) {
    return Stack(
      children: [
        TodoList(),
        if (state is TodoLoading)
          Container(
            color: Colors.black26,
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  },
)


// Pattern 2: Handle multiple states
BlocBuilder<TodoBloc, TodoState>(
  builder: (context, state) {
    return state.when(
      initial: () => Text('Welcome'),
      loading: () => CircularProgressIndicator(),
      loaded: (todos) => TodoList(todos: todos),
      error: (msg) => Text('Error: $msg'),
    );
  },
)


// Pattern 3: Combine multiple BLoCs
Row(
  children: [
    BlocBuilder<CounterBloc, int>(
      builder: (context, count) => Text('$count'),
    ),
    BlocBuilder<UserBloc, User>(
      builder: (context, user) => Text(user.name),
    ),
  ],
)


┌─────────────────────────────────────────────────────────────────┐
│  14. FILES DEMO TRONG PROJECT NÀY                                │
└─────────────────────────────────────────────────────────────────┘

lib/
├── main.dart                      → Setup BlocObserver, MultiBlocProvider
├── models/
│   ├── todo.dart                  → Model với Equatable
│   └── todo_filter.dart           → Enum filter
├── repositories/
│   └── todo_repository.dart       → Data layer với async operations
├── events/
│   ├── todo_event.dart            → 7 events khác nhau
│   ├── filter_event.dart          → Filter events
│   └── search_event.dart          → Search events
├── states/
│   ├── todo_state.dart            → 5 states (Initial, Loading, etc)
│   ├── filter_state.dart          → Filter state
│   └── search_state.dart          → Search state
├── blocs/
│   ├── todo_bloc.dart             → Main BLoC (restartable transformer)
│   ├── filter_bloc.dart           → Simple BLoC
│   ├── search_bloc.dart           → Debounce transformer
│   ├── filtered_todos_bloc.dart   → Listen 3 BLoCs khác
│   └── simple_bloc_observer.dart  → Log tất cả activities
└── screens/
    ├── home_screen.dart           → BlocBuilder, BlocListener, context.read()
    ├── add_todo_screen.dart       → Dispatch events
    ├── edit_todo_screen.dart      → Update todo
    └── statistics_screen.dart     → BlocConsumer demo


┌─────────────────────────────────────────────────────────────────┐
│  15. COMMANDS                                                    │
└─────────────────────────────────────────────────────────────────┘

# Install dependencies
flutter pub get

# Run app
flutter run

# Analyze code
flutter analyze

# Run tests
flutter test

*/
