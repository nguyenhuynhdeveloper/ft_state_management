/*
 * TỔNG HỢP TẤT CẢ WIDGETS VÀ METHODS CỦA BLOC
 * File này chứa ví dụ code về cách sử dụng mọi widget và method của BLoC
 */

// ==================== 1. BLOC CLASS ====================

import 'package:flutter_bloc/flutter_bloc.dart';

// Định nghĩa Bloc với Events và States
class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  // Constructor: nhận initial state
  ExampleBloc() : super(InitialState()) {
    
    // ✅ on<Event>() - Đăng ký event handler
    on<LoadDataEvent>(_onLoadData);
    
    // ✅ on<Event>() với transformer
    on<SearchEvent>(
      _onSearch,
      // Các transformers có sẵn:
      // - sequential(): Xử lý events tuần tự
      // - concurrent(): Xử lý events đồng thời
      // - restartable(): Cancel operation cũ khi có event mới
      // - droppable(): Bỏ qua event mới nếu đang xử lý
      // - debounce(): Delay xử lý event
      transformer: debounce(const Duration(milliseconds: 300)),
    );
  }

  // Event handler method
  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<ExampleState> emit, // ✅ Emitter - dùng để emit states
  ) async {
    // ✅ emit() - Phát state mới
    emit(LoadingState());
    
    try {
      // Xử lý logic
      final data = await fetchData();
      
      // Emit success state
      emit(LoadedState(data));
    } catch (error) {
      // Emit error state
      emit(ErrorState(error.toString()));
    }
  }

  Future<void> _onSearch(SearchEvent event, Emitter<ExampleState> emit) async {
    // Logic search
  }

  Future<dynamic> fetchData() async {
    // Giả lập fetch data
    await Future.delayed(const Duration(seconds: 1));
    return 'data';
  }
}

// Base classes
abstract class ExampleEvent {}
class LoadDataEvent extends ExampleEvent {}
class SearchEvent extends ExampleEvent {}

abstract class ExampleState {}
class InitialState extends ExampleState {}
class LoadingState extends ExampleState {}
class LoadedState extends ExampleState {
  final dynamic data;
  LoadedState(this.data);
}
class ErrorState extends ExampleState {
  final String message;
  ErrorState(this.message);
}

// ==================== 2. BLOC OBSERVER ====================

class MyBlocObserver extends BlocObserver {
  // ✅ onCreate - Được gọi khi BLoC được tạo
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate: ${bloc.runtimeType}');
  }

  // ✅ onEvent - Được gọi khi event được add vào BLoC
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('onEvent: ${bloc.runtimeType}, $event');
  }

  // ✅ onChange - Được gọi khi state thay đổi
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange: ${bloc.runtimeType}, $change');
  }

  // ✅ onTransition - Được gọi khi có transition
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('onTransition: ${bloc.runtimeType}, $transition');
  }

  // ✅ onError - Được gọi khi có error
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print('onError: ${bloc.runtimeType}, $error');
  }

  // ✅ onClose - Được gọi khi BLoC được đóng
  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('onClose: ${bloc.runtimeType}');
  }
}

// Setup BlocObserver trong main()
void setupBlocObserver() {
  // ✅ Bloc.observer - Set global observer
  Bloc.observer = MyBlocObserver();
}

// ==================== 3. BLOC PROVIDER WIDGETS ====================

import 'package:flutter/material.dart';

// ✅ BlocProvider - Cung cấp một BLoC cho widget tree
class BlocProviderExample extends StatelessWidget {
  const BlocProviderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // create: Tạo instance của BLoC
      create: (context) => ExampleBloc(),
      
      // lazy: Có tạo BLoC ngay lập tức không (default: true)
      // lazy: false,
      
      child: const ChildWidget(),
    );
  }
}

// ✅ BlocProvider.value - Provide BLoC instance có sẵn
class BlocProviderValueExample extends StatelessWidget {
  final ExampleBloc existingBloc;
  
  const BlocProviderValueExample({super.key, required this.existingBloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: existingBloc, // Sử dụng instance có sẵn
      child: const ChildWidget(),
    );
  }
}

// ✅ MultiBlocProvider - Provide nhiều BLoCs cùng lúc
class MultiBlocProviderExample extends StatelessWidget {
  const MultiBlocProviderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ExampleBloc>(
          create: (context) => ExampleBloc(),
        ),
        BlocProvider<AnotherBloc>(
          create: (context) => AnotherBloc(),
        ),
        // Có thể depend vào BLoC khác
        BlocProvider<DependentBloc>(
          create: (context) => DependentBloc(
            exampleBloc: context.read<ExampleBloc>(),
          ),
        ),
      ],
      child: const ChildWidget(),
    );
  }
}

class AnotherBloc extends Bloc<dynamic, dynamic> {
  AnotherBloc() : super(null);
}

class DependentBloc extends Bloc<dynamic, dynamic> {
  final ExampleBloc exampleBloc;
  DependentBloc({required this.exampleBloc}) : super(null);
}

// ==================== 4. BLOC BUILDER ====================

// ✅ BlocBuilder - Rebuild widget khi state thay đổi
class BlocBuilderExample extends StatelessWidget {
  const BlocBuilderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExampleBloc, ExampleState>(
      // buildWhen: Điều kiện để rebuild (optional)
      buildWhen: (previous, current) {
        // Chỉ rebuild khi state type thay đổi
        return previous.runtimeType != current.runtimeType;
      },
      
      // builder: Build UI dựa trên state
      builder: (context, state) {
        if (state is LoadingState) {
          return const CircularProgressIndicator();
        }
        
        if (state is LoadedState) {
          return Text('Data: ${state.data}');
        }
        
        if (state is ErrorState) {
          return Text('Error: ${state.message}');
        }
        
        return const Text('Initial');
      },
    );
  }
}

// ✅ BlocBuilder với bloc parameter (không dùng Provider)
class BlocBuilderWithBlocExample extends StatelessWidget {
  final ExampleBloc bloc;
  
  const BlocBuilderWithBlocExample({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExampleBloc, ExampleState>(
      bloc: bloc, // Provide BLoC trực tiếp
      builder: (context, state) {
        return Text('State: $state');
      },
    );
  }
}

// ==================== 5. BLOC LISTENER ====================

// ✅ BlocListener - Lắng nghe state changes, không rebuild
class BlocListenerExample extends StatelessWidget {
  const BlocListenerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExampleBloc, ExampleState>(
      // listenWhen: Điều kiện để listen (optional)
      listenWhen: (previous, current) {
        // Chỉ listen khi state là ErrorState hoặc LoadedState
        return current is ErrorState || current is LoadedState;
      },
      
      // listener: Thực hiện side effects
      listener: (context, state) {
        if (state is ErrorState) {
          // Show error snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        
        if (state is LoadedState) {
          // Navigate to another screen
          // Navigator.push(...)
        }
      },
      
      // child: Widget con (không rebuild khi state thay đổi)
      child: const ChildWidget(),
    );
  }
}

// ==================== 6. BLOC CONSUMER ====================

// ✅ BlocConsumer - Kết hợp BlocBuilder và BlocListener
class BlocConsumerExample extends StatelessWidget {
  const BlocConsumerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExampleBloc, ExampleState>(
      // listenWhen: Điều kiện để listen
      listenWhen: (previous, current) {
        return current is ErrorState;
      },
      
      // listener: Side effects
      listener: (context, state) {
        if (state is ErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      
      // buildWhen: Điều kiện để rebuild
      buildWhen: (previous, current) {
        return current is! ErrorState; // Không rebuild khi ErrorState
      },
      
      // builder: Build UI
      builder: (context, state) {
        if (state is LoadingState) {
          return const CircularProgressIndicator();
        }
        
        if (state is LoadedState) {
          return Text('Data: ${state.data}');
        }
        
        return const Text('Initial');
      },
    );
  }
}

// ==================== 7. MULTI BLOC LISTENER ====================

// ✅ MultiBlocListener - Lắng nghe nhiều BLoCs
class MultiBlocListenerExample extends StatelessWidget {
  const MultiBlocListenerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ExampleBloc, ExampleState>(
          listener: (context, state) {
            // Handle ExampleBloc states
          },
        ),
        BlocListener<AnotherBloc, dynamic>(
          listener: (context, state) {
            // Handle AnotherBloc states
          },
        ),
      ],
      child: const ChildWidget(),
    );
  }
}

// ==================== 8. REPOSITORY PROVIDER ====================

// ✅ RepositoryProvider - Provide repository (không phải BLoC)
class RepositoryProviderExample extends StatelessWidget {
  const RepositoryProviderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MyRepository(),
      child: const ChildWidget(),
    );
  }
}

// ✅ MultiRepositoryProvider
class MultiRepositoryProviderExample extends StatelessWidget {
  const MultiRepositoryProviderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MyRepository>(
          create: (context) => MyRepository(),
        ),
        RepositoryProvider<AnotherRepository>(
          create: (context) => AnotherRepository(),
        ),
      ],
      child: const ChildWidget(),
    );
  }
}

class MyRepository {}
class AnotherRepository {}

// ==================== 9. CONTEXT EXTENSIONS ====================

// ✅ context.read<T>() - Đọc BLoC/Repository, KHÔNG listen changes
class ContextReadExample extends StatelessWidget {
  const ContextReadExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Đọc BLoC và dispatch event
        context.read<ExampleBloc>().add(LoadDataEvent());
        
        // Đọc Repository
        final repository = context.read<MyRepository>();
      },
      child: const Text('Load Data'),
    );
  }
}

// ✅ context.watch<T>() - Đọc BLoC/Repository, LISTEN changes
class ContextWatchExample extends StatelessWidget {
  const ContextWatchExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Widget sẽ rebuild khi ExampleBloc state thay đổi
    final bloc = context.watch<ExampleBloc>();
    final state = bloc.state;
    
    return Text('Current state: $state');
  }
}

// ✅ context.select<T, R>() - Chỉ listen một phần của state
class ContextSelectExample extends StatelessWidget {
  const ContextSelectExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Chỉ rebuild khi data thay đổi, không rebuild khi state type thay đổi
    final data = context.select<ExampleBloc, String?>((bloc) {
      final state = bloc.state;
      if (state is LoadedState) {
        return state.data.toString();
      }
      return null;
    });
    
    return Text('Data: $data');
  }
}

// ==================== 10. BLOC SELECTOR ====================

// ✅ BlocSelector - Rebuild chỉ khi một phần của state thay đổi
class BlocSelectorExample extends StatelessWidget {
  const BlocSelectorExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ExampleBloc, ExampleState, String?>(
      // selector: Chọn phần data cần watch
      selector: (state) {
        if (state is LoadedState) {
          return state.data.toString();
        }
        return null;
      },
      
      // builder: Chỉ rebuild khi selected data thay đổi
      builder: (context, data) {
        return Text('Data: $data');
      },
    );
  }
}

// ==================== 11. BLOC UTILITIES ====================

class BlocUtilitiesExample {
  void demonstrateUtilities(ExampleBloc bloc) {
    // ✅ bloc.state - Lấy state hiện tại
    final currentState = bloc.state;
    
    // ✅ bloc.stream - Stream của states
    bloc.stream.listen((state) {
      print('New state: $state');
    });
    
    // ✅ bloc.add() - Thêm event vào BLoC
    bloc.add(LoadDataEvent());
    
    // ✅ bloc.close() - Đóng BLoC (dispose)
    // bloc.close();
    
    // ✅ bloc.isClosed - Check BLoC đã đóng chưa
    if (bloc.isClosed) {
      print('BLoC is closed');
    }
  }
}

// ==================== 12. STREAM TRANSFORMERS ====================

import 'package:bloc_concurrency/bloc_concurrency.dart';

class StreamTransformersExample extends Bloc<dynamic, dynamic> {
  StreamTransformersExample() : super(null) {
    // ✅ sequential() - Xử lý events tuần tự (default)
    on<Event1>(
      _handler,
      transformer: sequential(),
    );
    
    // ✅ concurrent() - Xử lý tất cả events đồng thời
    on<Event2>(
      _handler,
      transformer: concurrent(),
    );
    
    // ✅ restartable() - Cancel operation cũ khi có event mới
    on<Event3>(
      _handler,
      transformer: restartable(),
    );
    
    // ✅ droppable() - Bỏ qua event mới nếu đang xử lý
    on<Event4>(
      _handler,
      transformer: droppable(),
    );
    
    // ✅ debounce() - Delay xử lý event
    on<Event5>(
      _handler,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
  }
  
  Future<void> _handler(dynamic event, Emitter<dynamic> emit) async {
    // Handler logic
  }
}

class Event1 {}
class Event2 {}
class Event3 {}
class Event4 {}
class Event5 {}

// ==================== DUMMY WIDGET ====================

class ChildWidget extends StatelessWidget {
  const ChildWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

/*
 * TÓM TẮT TẤT CẢ WIDGETS & METHODS:
 * 
 * 1. BLOC CLASS:
 *    - Bloc<Event, State>
 *    - on<Event>()
 *    - emit()
 *    - add()
 *    - state
 *    - stream
 *    - close()
 *    - isClosed
 * 
 * 2. BLOC OBSERVER:
 *    - onCreate()
 *    - onEvent()
 *    - onChange()
 *    - onTransition()
 *    - onError()
 *    - onClose()
 * 
 * 3. PROVIDER WIDGETS:
 *    - BlocProvider
 *    - BlocProvider.value
 *    - MultiBlocProvider
 *    - RepositoryProvider
 *    - MultiRepositoryProvider
 * 
 * 4. CONSUMER WIDGETS:
 *    - BlocBuilder
 *    - BlocListener
 *    - BlocConsumer
 *    - MultiBlocListener
 *    - BlocSelector
 * 
 * 5. CONTEXT METHODS:
 *    - context.read<T>()
 *    - context.watch<T>()
 *    - context.select<T, R>()
 * 
 * 6. TRANSFORMERS:
 *    - sequential()
 *    - concurrent()
 *    - restartable()
 *    - droppable()
 *    - debounce()
 */
