import 'dart:async';

/// BLoC Counter dùng Dart core StreamController.
/// - Có 2 controller: _eventController (input) và _stateController (output).
/// - Tự quản lý state (_count) và mapping event -> state.
/// - Phù hợp khi logic đơn giản, ít operator.

/// Các sự kiện đơn giản cho Counter.
abstract class CounterEvent {}   // Tạo ra 1 class Event
class Increment extends CounterEvent {}
class Decrement extends CounterEvent {}
class Reset extends CounterEvent {}

class CounterBlocCore {
  // State hiện tại (nội bộ)
  int _count = 0;  // Biến này được giữ riêng biệt


  // Tạo ra 2 cái StreamController để phục vụ Bloc
  // Output state stream: nơi UI lắng nghe -- Controller lắng nghe giá trị đầu ra dữ liệu
  final _stateController = StreamController<int>.broadcast();

  // Input event stream: nơi UI phát sự kiện -- Đầu vào phát sự kiện
  final _eventController = StreamController<CounterEvent>();

  // Constructor của Bloc
  CounterBlocCore() {
    // Phần lắng nghe event để đưa ra thay đổi giá trị của state --- tự mapping sang state
    _eventController.stream.listen(_mapEventToState);  
    // Phát initial state cho UI
    _stateController.add(_count);
  }

  /// Stream cho UI (StreamBuilder dùng cái này) -- để UI lấy state để vẽ view
  Stream<int> get stream => _stateController.stream;

  /// Các entry-point phát event (thay vì expose sink)
  void increment() => _eventController.add(Increment());  // Thêm các event vào đường ống Controller
  void decrement() => _eventController.add(Decrement());
  void reset()     => _eventController.add(Reset());

// Hàm ánh xạ từ sự kiện tới dữ liệu
  void _mapEventToState(CounterEvent event) {
    if (event is Increment) {
      _count += 1;
    } else if (event is Decrement) {
      _count -= 1;
    } else if (event is Reset) {
      _count = 0;
    }
    
    // Phát state(data)) mới cho UI -- Để UI hứng được state
    _stateController.add(_count);
  }

  /// Giải phóng tài nguyên
  void dispose() {
    _eventController.close();
    _stateController.close();
  }
}
