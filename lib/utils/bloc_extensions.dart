// BLoC Extensions - Các extension methods hữu ích cho BLoC
// Demo cách sử dụng extension để mở rộng functionality

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Extension cho BuildContext để dễ dàng access BLoC
extension BlocContextExtensions on BuildContext {
  // Đọc BLoC mà không listen changes
  // Equivalent: BlocProvider.of<T>(context, listen: false)
  T readBloc<T extends StateStreamableSource<Object?>>() {
    return read<T>();
  }

  // Đọc BLoC và listen changes
  // Equivalent: BlocProvider.of<T>(context)
  T watchBloc<T extends StateStreamableSource<Object?>>() {
    return watch<T>();
  }
}

// Extension cho Bloc để thêm các utility methods
extension BlocExtensions<Event, State> on Bloc<Event, State> {
  // Helper method để check state hiện tại
  bool isState<T extends State>() {
    return state is T;
  }

  // Helper method để get state với type cụ thể
  T? getState<T extends State>() {
    return state is T ? state as T : null;
  }
}
