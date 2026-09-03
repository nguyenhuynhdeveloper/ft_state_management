# HƯỚNG DẪN SỬ DỤNG ỨNG DỤNG DEMO BLOC PATTERN

## 📚 TỔNG QUAN

Ứng dụng này demo **TOÀN BỘ** các tính năng của BLoC Pattern trong Flutter, bao gồm:

### ✅ Các khái niệm BLoC đã được demo:

1. **Events & States**
   - Định nghĩa Events (yêu cầu từ UI)
   - Định nghĩa States (trạng thái của ứng dụng)
   - Sử dụng Equatable để so sánh

2. **Bloc Class**
   - Khởi tạo BLoC với initial state
   - Đăng ký event handlers với `on<Event>()`
   - Xử lý async operations
   - Emit states với `emit()`
   - Dependency injection (Repository)

3. **BLoC Widgets**
   - `BlocProvider` - Cung cấp BLoC cho widget tree
   - `MultiBlocProvider` - Cung cấp nhiều BLoCs
   - `BlocBuilder` - Rebuild UI khi state thay đổi
   - `BlocListener` - Thực hiện side effects (snackbar, navigation)
   - `BlocConsumer` - Kết hợp Builder và Listener

4. **Context Methods**
   - `context.read<T>()` - Đọc BLoC không listen changes
   - `context.watch<T>()` - Đọc BLoC và listen changes

5. **Stream Transformers**
   - `debounce()` - Delay xử lý event (search)
   - `restartable()` - Cancel operation cũ khi có event mới

6. **BlocObserver**
   - Log tất cả events, states, transitions
   - Debug và monitor BLoC lifecycle

7. **BLoC Communication**
   - Một BLoC lắng nghe nhiều BLoCs khác (FilteredTodosBloc)
   - Combine states từ nhiều BLoCs

---

## 📁 CẤU TRÚC DỰ ÁN

```
lib/
├── main.dart                          # Entry point, setup BlocObserver
├── models/                            # Data models
│   ├── todo.dart                      # Todo model với Equatable
│   └── todo_filter.dart               # Enum cho filter types
├── repositories/                      # Data layer
│   └── todo_repository.dart           # Xử lý data (CRUD operations)
├── events/                            # Event definitions
│   ├── todo_event.dart                # Todo events
│   ├── filter_event.dart              # Filter events
│   └── search_event.dart              # Search events
├── states/                            # State definitions
│   ├── todo_state.dart                # Todo states
│   ├── filter_state.dart              # Filter states
│   └── search_state.dart              # Search states
├── blocs/                             # BLoC logic
│   ├── todo_bloc.dart                 # Main todo BLoC
│   ├── filter_bloc.dart               # Filter BLoC
│   ├── search_bloc.dart               # Search BLoC với debounce
│   ├── filtered_todos_bloc.dart       # Combine multiple BLoCs
│   └── simple_bloc_observer.dart      # BLoC observer cho logging
├── screens/                           # UI screens
│   ├── home_screen.dart               # Main screen (BlocBuilder, BlocListener)
│   ├── add_todo_screen.dart           # Add todo screen
│   ├── edit_todo_screen.dart          # Edit todo screen
│   └── statistics_screen.dart         # Statistics (BlocConsumer)
└── utils/                             # Utilities
    └── bloc_extensions.dart           # Extension methods
```

---

## 🎯 TÍNH NĂNG ỨNG DỤNG

1. **Quản lý Todos**
   - ✅ Thêm todo mới
   - ✅ Sửa todo
   - ✅ Xóa todo
   - ✅ Toggle trạng thái completed/uncompleted
   - ✅ Xóa tất cả todos đã hoàn thành

2. **Lọc & Tìm Kiếm**
   - ✅ Filter: All / Active / Completed
   - ✅ Search với debounce (300ms)
   - ✅ Kết hợp filter và search

3. **Thống Kê**
   - ✅ Tổng số todos
   - ✅ Số todos chưa hoàn thành
   - ✅ Số todos đã hoàn thành
   - ✅ Tỷ lệ hoàn thành
   - ✅ Danh sách todos gần đây

---

## 🚀 CÁCH CHẠY ỨNG DỤNG

### 1. Kiểm tra Flutter
```bash
flutter --version
flutter doctor
```

### 2. Cài đặt dependencies
```bash
cd /Users/MobileDev/flutter/ft_state_management
flutter pub get
```

### 3. Chạy ứng dụng
```bash
# Chạy trên device/emulator đang connect
flutter run

# Hoặc chạy trên Chrome (web)
flutter run -d chrome

# Hoặc chạy trên macOS
flutter run -d macos
```

---

## 📖 GIẢI THÍCH CHI TIẾT CÁC FILE

### 1. **main.dart**
- Setup `BlocObserver` để log tất cả BLoC activities
- Sử dụng `MultiBlocProvider` để provide 4 BLoCs:
  - TodoBloc (với repository injection)
  - FilterBloc
  - SearchBloc
  - FilteredTodosBloc (depend on 3 BLoCs trên)

### 2. **todo_bloc.dart** (★ QUAN TRỌNG NHẤT)
```dart
// Các tính năng được demo:
✅ Constructor với dependency injection
✅ Multiple event handlers với on<Event>()
✅ Async operations với await
✅ Error handling với try-catch
✅ Emit multiple states (Loading, Loaded, Error, Success)
✅ State management với Emitter<State>
✅ Transformer: restartable()
```

### 3. **search_bloc.dart**
```dart
// Demo debounce transformer
✅ Debounce 300ms để tránh search quá nhiều lần khi user typing
```

### 4. **filtered_todos_bloc.dart**
```dart
// Demo BLoC communication
✅ Listen to 3 BLoCs khác (TodoBloc, FilterBloc, SearchBloc)
✅ Combine states từ nhiều BLoCs
✅ Transform và filter data
```

### 5. **home_screen.dart** (★ QUAN TRỌNG)
```dart
// Demo tất cả BLoC widgets:
✅ BlocBuilder<SearchBloc> - Rebuild search field
✅ BlocBuilder<FilterBloc> - Rebuild filter chips
✅ BlocBuilder<FilteredTodosBloc> - Rebuild statistics
✅ BlocListener<TodoBloc> - Show snackbar cho success/error
✅ context.read<TodoBloc>() - Dispatch events
✅ Nested BlocBuilders - Multiple BLoCs in one widget
```

### 6. **statistics_screen.dart**
```dart
// Demo BlocConsumer:
✅ BlocConsumer = BlocListener + BlocBuilder
✅ Listener: Show snackbar
✅ Builder: Build UI với statistics
```

---

## 🎓 KIẾN THỨC QUAN TRỌNG

### 1. **Khi nào dùng context.read() vs context.watch()?**
```dart
// ✅ Dùng context.read() khi:
- Dispatch events
- Call methods
- Không cần rebuild widget khi state thay đổi

// ✅ Dùng context.watch() khi:
- Cần rebuild widget khi state thay đổi
- Thường dùng trong build method
```

### 2. **Khi nào dùng BlocBuilder vs BlocListener vs BlocConsumer?**
```dart
// BlocBuilder: Chỉ rebuild UI
// BlocListener: Chỉ side effects (không rebuild)
// BlocConsumer: Cả hai (rebuild + side effects)
```

### 3. **Tại sao cần Equatable?**
```dart
// Equatable giúp BLoC so sánh states/events dễ dàng
// Nếu state mới == state cũ => không rebuild widget
// Giúp optimize performance
```

### 4. **Stream Transformers là gì?**
```dart
// Transformers xử lý cách events được handle:
- debounce(): Delay xử lý event
- restartable(): Cancel operation cũ khi có event mới
- sequential(): Xử lý events tuần tự
- concurrent(): Xử lý events đồng thời
- droppable(): Drop events đang xử lý khi có event mới
```

---

## 🔍 CÁCH TEST ỨNG DỤNG

1. **Thêm Todo**: Nhấn FAB (+) ở góc phải dưới
2. **Toggle Todo**: Nhấn checkbox bên trái todo item
3. **Edit Todo**: Nhấn icon edit (✏️)
4. **Delete Todo**: Nhấn icon delete (🗑️)
5. **Search Todo**: Gõ vào search bar (sẽ debounce 300ms)
6. **Filter Todos**: Nhấn chips: All / Active / Completed
7. **View Statistics**: Nhấn icon bar chart ở app bar
8. **Clear Completed**: Nhấn icon delete_sweep ở app bar
9. **Refresh**: Nhấn icon refresh ở app bar

---

## 📊 LOGGING

Mở console/terminal khi chạy app để xem BLoC logs:
- ✨ onCreate: Khi BLoC được tạo
- 🎯 onEvent: Khi event được dispatch
- 📝 onChange: Khi state thay đổi
- 🔄 onTransition: Chi tiết transition (currentState → event → nextState)
- ❌ onError: Khi có error
- 🔒 onClose: Khi BLoC được dispose

---

## 💡 MẸO VÀ LƯU Ý

1. **MultiBlocProvider order quan trọng**: Đặt BLoCs không depend lên trên, BLoCs depend xuống dưới
2. **Dispose BLoCs tự động**: BlocProvider tự động dispose khi widget bị remove
3. **BuildContext**: Luôn dùng context từ widget có BlocProvider ancestor
4. **Performance**: Dùng const constructors khi có thể
5. **Testing**: Tách repository ra giúp dễ mock và test BLoC

---

## 🐛 TROUBLESHOOTING

**Lỗi: "Could not find the correct Provider"**
- Đảm bảo widget có BlocProvider ancestor
- Check MultiBlocProvider order

**Widget không rebuild khi state thay đổi**
- Kiểm tra Equatable props
- Đảm bảo emit state MỚI (không phải cùng instance)

**Events không được xử lý**
- Check on<Event>() đã được đăng ký trong constructor
- Check event type đúng

---

## 📦 DEPENDENCIES

```yaml
dependencies:
  flutter_bloc: ^8.1.1        # BLoC widgets và pattern
  equatable: ^2.0.5           # So sánh objects dễ dàng
  bloc_concurrency: ^0.2.2    # Stream transformers
```

---

## 🎉 KẾT LUẬN

Ứng dụng này demo **ĐẦY ĐỦ** các tính năng của BLoC Pattern:
- ✅ Events & States
- ✅ Bloc class với all methods
- ✅ All BLoC widgets (Provider, Builder, Listener, Consumer)
- ✅ context.read() và context.watch()
- ✅ Stream transformers (debounce, restartable)
- ✅ BlocObserver
- ✅ Multiple BLoCs communication
- ✅ Dependency injection
- ✅ Error handling
- ✅ Async operations

**Code sạch, có comments tiếng Việt chi tiết, dễ hiểu, và chạy ngay được!**

---

Made with ❤️ for learning BLoC Pattern
