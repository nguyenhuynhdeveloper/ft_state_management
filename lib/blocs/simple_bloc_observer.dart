// SimpleBlocObserver - Observer để log tất cả các events, states, transitions và errors
// Rất hữu ích cho debugging

import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  // onChange được gọi mỗi khi state của bất kỳ BLoC nào thay đổi
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('📝 ${bloc.runtimeType} $change');
  }

  // onEvent được gọi mỗi khi một event được add vào BLoC
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('🎯 ${bloc.runtimeType} $event');
  }

  // onTransition được gọi mỗi khi có transition từ state này sang state khác
  // Transition bao gồm: currentState + event + nextState
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('🔄 ${bloc.runtimeType} $transition');
  }

  // onError được gọi khi có error xảy ra trong BLoC
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print('❌ ${bloc.runtimeType} $error');
  }

  // onCreate được gọi khi một BLoC được khởi tạo
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('✨ ${bloc.runtimeType} được tạo');
  }

  // onClose được gọi khi một BLoC được đóng
  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('🔒 ${bloc.runtimeType} được đóng');
  }
}
