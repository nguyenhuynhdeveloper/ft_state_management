19/09/2023

### https://codewithandrea.com/articles/flutter-state-management-riverpod/

Riverpod cung cấp tám loại Provider khác nhau, tất cả đều phù hợp cho các trường hợp sử dụng riêng biệt

### cú pháp .notifier sử dụng để có thể thay đổi state của Provider , chỉ khả dụng trên

StateProvider
StateNotifierProvider
NotifierProvider

1. Provider
2. StateProvider : Hoàn toàn có thể thay đổi giá trị state bằng cách gán giá trị trực tiếp cho state --- legacy
3. StateNotifierProvider : --- legacy
4. FutureProvider
5. StreamProvider
6. ChangeNotifierProvider : --- legacy
7. NotifierProvider : Riverpod 2.0
8. AsyncNotifierProvider : Riverpod 2.0

9. Provider

// provider that returns a string value
final helloWorldProvider = Provider<String>((ref) {
return 'Hello world';
});

State không thể thay đổi
Phù hợp truy cập kho lưu trữ, Trình ghi nhật ký hoặc class mà state không thay đổi

Ví dụ: return ra 1 DateFormat

// declare the provider
final dateFormatterProvider = Provider<DateFormat>((ref) {
return DateFormat.MMMEd();
});

class SomeWidget extends ConsumerWidget {
@override
Widget build(BuildContext context, WidgetRef ref) {
// retrieve the formatter
final formatter = ref.watch(dateFormatterProvider);
// use it
return Text(formatter.format(DateTime.now()));
}
}

2. StateProvider
   StateProvider rất tốt để lưu trữ các đối tượng trạng thái đơn giản có thể thay đổi, chẳng hạn như giá trị bộ đếm:

final counterStateProvider = StateProvider<int>((ref) {
return 0;
});

Nếu bạn lắng nghe trong build method , widget có thể rebuild khi state thay đổi
Bạn cũng có thể thay đổi giá trị cuẩ State bên trong button callback bằng cách sử dụng ref.read()

class CounterWidget extends ConsumerWidget {
@override
Widget build(BuildContext context , WidgetRef ref) {
// Lăng nghe state của Provider và rebuild khi value thay đổi
final counter = ref.watch(CounterStateProvider) ;
return ElevatedButton(
// Sử dụng state của Provider
child: Text('Value: $counter'),
// Thay đổi state bên trong button callback
onPress: () => ref.read(counterStateProvider.notifier).state++ // Cộng thêm 1 đơn vị vào state
// onPress: () => ref.read(counterStateProvider.notifier).state = 10 // Gán trực tiếp giá trị cho state
)
}
}

StateProvider là 1 ý tưởng tuyệt vời cho quản lý state dạng enums, strings, booleans, numbers
NotifierProvider cũng có thể sử dụng cho mục đích tương tự nhưng linh hoạt hơn. Đối với state phức tạp hơn hoặc không đồng bộ thì sử dụng FutureProvider, StreamProvider, AsyncNotifierProvider

3. StateNotifierProvider

# https://riverpod.dev/docs/providers/state_notifier_provider

Sử dụng để lắng nghe và expose StateNotifier
StateNotifierProvider phải đi kèm với StateNotifier : rất lý tưởng để quản lý state có thể thay đổi theo phản ứng với sự kiện hoặc tương tác của người dùng
StateNotifierProvider và StateNotifier là giải phảp được Riverpod để xuất để quản lý state có thể thay đổi được theo tương tác của người dùng

Kể từ phiên bản Riverpod 2.0 StateNotifier được coi là cũ và cân nhắc được thay thế bởi AsyncNotifier

Thường sử dụng cho các trường hợp
Tập trung logic để thay đổi state (hay còn gọi là business logic ) tại 1 nơi duy nhất , Cải thiện Khả năng bảo trì theo thời gian
Thay đổi state khi có sự kiện hoặc tương tác người dùng

Ví dụ , Có thể sử dụng StateNotifierProvider để triển khai danh sách việc cần làm . Cho phép hiển thị các phương thức thêm , sửa xoá , todoList khi tương tác người dùng

State của StateNotifier phải là bất biến
Chúng ta có thể sử dụng gói Freezed để hỗ trợ triển khai generate code

@immutable
class Todo {
const Todo{required this.id, required this.description , required this.completed }) ;

    // Tất cả cá properties nên được khai báo kiểu final

    final String id;
    final String description;
    final bool completed;

    // Vì Todo là bất biến nên chúng ta triển khai một phương pháo cho phép sao chép - việc ần làm có nội dung khác đi 1 chủt

    Todo copyWith({String? id, String? description, bool? completed}){
        return Todo(
            id: id ?? this.id,
            description: description ?? this.description ,
            completed: completed ?? this.completed,
        );
    }

}

// Class StateNotifier sẽ được pass tới StateNotifierProvider
// Class StateNotifierProvider không được hiển thị trạng thái bên ngoài thuộc tính state của nó , có nghĩa là không có thuộc tính getters nào được công khai

Class TodoNotifier extends StateNotifier<List<Todo>> {

    // Chúng ta khởi tạo  list todo là 1 empty list

    TodosNotifier(): super([]) ;
    // Chấp nhận UI thêm todos

    void addTodo(Todo todo) {
     // Vì state là bất biến nên chúng ta không thể sử dụng state.add(todo)
     // Thay vào đó chúng ta sẽ tạo 1 list mới cái mà chứa  list item trước đó và 1 item mới

    // Sử dụng Dart's spread operator hữu ích cho trường hợp này
    state = [...state, todo];
    // Không cần gọi  notifyListeners hoặc cái gì khá
    // calling state = sẽ tự động rebuild lại UI khi cần thiết
    }

    // Chấp nhận UI remove todos
     void removeTodo(String todoId) {
        // State là bất biến , Vì vậy chỉ có thể tạo 1 list mưới thay thế list cũ đã tồn tại

        state= [ for(final todo in state)
        if (todo.id != todoId) todo , ];
     }

     // Hàm đánh dấu todo completed
     void toggle(String todoId) {
        state= [
            for (final todo in state )
            if(todo.id == todoId)
            // Vì State là bất biến nên sử dụng copyWith để thay đổi phần tử todo  sang 1 phần tử  todo khác
            todo.copyWith(completed: !todo.completed)
            else
            todo,
        ]
     }

}

// Cuối cùng tạo StateNotifierProvider để chấp nhận UI tương tác với TodoNotifier class

final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>> ((ref) {
return TodoNotifier()
})

Giờ đã có defined của StateNotifierProvider . ta có thể sử dụng nó để tương tác với list todo ở trên UI

class TodoListView extends ConsumerWidget {
const TodoListView({Key? key}): super(key: key);

@override
Widget build(BuildContext context, WidgetRef ref) {
// rebuild the widget when the todo list changes
List<Todo> todos = ref.watch(todosProvider);

    // Let's render the todos in a scrollable list view
    return ListView(
      children: [
        for (final todo in todos)
          CheckboxListTile(
            value: todo.completed,
            // When tapping on the todo, change its completed status
            onChanged: (value) => ref.read(todosProvider.notifier).toggle(todo.id),
            title: Text(todo.description),
          ),
      ],
    );

}
}

4. FutureProvider

Bạn muốn nhận kết quả từ API trả về 1 Future

Chỉ cần tạo 1 FutureProvider như thế này

final weatherFutureProvider = FutureProvider.autoDispose<Weather>((ref) {
// get repository từ Provider bên dưới
final weatherRepository = ref.watch(weatherRepositoryProvider);
// Call method cái mà return a Future<Weather>
return weatherRepository.getWeather(city: 'London');
});

// Ví dụ weather repository provider
final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
return WeatherRepository(); // Định nghĩa ở 1 nơi khác
});

FutureProvider thường được sử dụng với autoDispose modifier

Sau đó bạn có thể xem build method , và sử dụng result AsyncValue (data, loading , error ) tới UI

Widget build(BuildContext context, WidgetRef ref) {
// watch the FutureProvider and get an AsyncValue<Weather>
final weatherAsync = ref.watch(weatherFutureProvider);
// use pattern matching to map the state to the UI
return weatherAsync.when(
loading: () => const CircularProgressIndicator(),
error: (err, stack) => Text('Error: $err'),
data: (weather) => Text(weather.toString()),
);
}

Note : Khi lắng nghe FutureProvider<T> hoặc StreamProvider<T> , return 1 type an AsyncValue<T> ,
AsyncValue là 1 lớp tiện ích để sử lý cá data không đồng bộ trong Riverpod

FutureProvider rất hữu ích cho

- thực hiện các hoạt động không đồng bộ như call API
- Xử lý lỗi và trạng thái loading cho hoạt động Không đồng bộ
- combine nhiều giá trị không đồng bộ thành 1 giá trị khác
- re-fetch and refresh data ( hữu ích cho pull- to - refresh hành động)
