import 'dart:async';
import 'package:rxdart/rxdart.dart';

/// BLoC Counter dùng RxDart:
/// - BehaviorSubject<int> giữ "giá trị hiện tại" của state -> listener mới nhận ngay.
/// - PublishSubject<CounterEvent> cho luồng sự kiện.
/// - Demo debounceTime để gom click nhanh trong 150ms thành 1 lần xử lý.
/// - Dễ mở rộng với các operators như: scan, switchMap, combineLatest, etc.

abstract class CounterEvent {}  // abstract để tạo các class event
class Increment extends CounterEvent {}   // Tạo các class từ abstract class
class Decrement extends CounterEvent {}
class Reset extends CounterEvent {}

// Class Bloc sử dụng RxDart
class CounterBlocRx {

  // Tạo ra 2 cái Subject để phục vụ Bloc
  /// Subject state: giữ last value (khởi tạo 0)
  final BehaviorSubject<int> _state = BehaviorSubject<int>.seeded(0);   // Giá trị state được quản lý bởi RxDart bằng BehaviorSubject

  /// Subject event: không giữ lại
  final PublishSubject<CounterEvent> _events = PublishSubject<CounterEvent>();  // Các event được quản lý bởi PublishSubject

  late final StreamSubscription _sub;   // Biến quản lý các đối tượng đăng ký 

  CounterBlocRx() {
    // Pipeline xử lý:
    // 1) debounceTime: ví dụ gom các lần nhấn quá nhanh trong 150ms
    // 2) scan: "tích lũy" event -> state mới (tương tự fold nhưng chạy theo thời gian)
    _sub = _events
        .debounceTime(const Duration(milliseconds: 150))
        .scan<int>((acc, event, index) {
          if (event is Increment) return acc + 1;
          if (event is Decrement) return acc - 1;
          if (event is Reset)     return 0;
          return acc;
        }, _state.value) // giá trị tích lũy ban đầu là state hiện tại
        .listen((newCount) {
          _state.add(newCount); // đẩy state mới ra --- Để ui vẽ lại view mới
        });
  }

  /// Stream cho UI lắng nghe 
  Stream<int> get stream => _state.stream;

  /// Lấy giá trị hiện tại nhanh (ưu thế của BehaviorSubject)
  int get value => _state.value;   // _state.value là gía trị của value trong state

  /// Entry-point phát event
  void increment() => _events.add(Increment());   // Hàm mà trả ra 1 hành động phát event
  void decrement() => _events.add(Decrement());
  void reset()     => _events.add(Reset());

  void dispose() {
    _sub.cancel();
    _events.close();
    _state.close();
  }
}
