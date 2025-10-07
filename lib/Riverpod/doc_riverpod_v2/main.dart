import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'todo.dart';

// Trong ứng dụng sử dụng 3 loại Provider 
// Provider : State không thay đổi 
// StateProvider : State kiểu đơn giản có thể thay đổi giá trị state
// NotifierProvider : State kiểu phức tạp có thể thay đổi giá trị của state -- state cần được extends Notifier

// Một vài key sử 
final addTodoKey = UniqueKey();
final activeFilterKey = UniqueKey();
final completedFilterKey = UniqueKey();
final allFilterKey = UniqueKey();

// Tạo 1 todo list và khởi tạo nơ với 1 giá trị được xácc định trước 

// Provider : Chứa danh sách các việcc cần phải làm 
// Sử dụng StateNotifierProvider vì List<Todo> là 1 đối tượng phức tạp , với logic và nghiệp vụ nâng cao như chỉnh sửa việc cần làm 
final todoListProvider = NotifierProvider<TodoList, List<Todo>>(TodoList.new);

// Biến enum để filter ra các giá trị của todo 
enum TodoListFilter {
  all,   // Giá trị thực của nó đang là số 1
  active,
  completed,
}

// Provider: cho bộ lọc 
// Sử dụng StateProvider ở đây vì không có logic phức tạp gía trị của nó chỉ là enum  
final todoListFilter = StateProvider((_) => TodoListFilter.all);

// Số lượng việc cần làm chưa hoàn thành 
// Bằng cách sử dụng Provider giá trị này được lưu vào bộ đệm giúp nó hoạt động hiệu quả
// thâm chí nhiều widget cũng có thể đọc đượcc giá trị trong Provider 

// Tính ra Số lượng việc chưa hoàn thành 
final uncompletedTodosCount = Provider<int>((ref) {
  return ref.watch(todoListProvider).where((todo) => !todo.completed).length;
});

// Provider: Chứa danh sáchh các việc cần làm đã được lọcc 
// Danh sáchh việc cần làm sau khi áp dụng Provider todoListFilterr 
// Điều này cũng sử dụng Provider để tránh tính toán lại danh sách đã lọc trừ khi bộ lọc hoặcc cập nhật danh sách việc cần làm 

final filteredTodos = Provider<List<Todo>>((ref) {   // <List<Todo>>  : là kiểu dữ liệu mà Provider này sẽ trả ra 
  final filter = ref.watch(todoListFilter);   //  Giá trị lọc đang được chọn 
  final todos = ref.watch(todoListProvider);   // Danh sáchh tất cả các việc cần làm 

  switch (filter) {
    case TodoListFilter.completed:
      return todos.where((todo) => todo.completed).toList();
    case TodoListFilter.active:
      return todos.where((todo) => !todo.completed).toList();
    case TodoListFilter.all:
      return todos;
  }
});

// void main() {
//   runApp(const ProviderScope(child: MyApp()));
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends HookConsumerWidget {       // Đây là StatelessWidget có sử dụng flutter_hooks
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(filteredTodos);   // Lấy ra danh sách các việcc làm 
    final newTodoController = useTextEditingController();   //Đây là 1 hook của Flutter_hook 

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),  // Tắt bàn phím khi blur ra bên ngoài 
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          children: [
            const Title(),
            TextField(
              key: addTodoKey,
              controller: newTodoController,  // controller của TextField 
              decoration: const InputDecoration(
                labelText: 'What needs to be done?',
              ),
              onSubmitted: (value) {      // Khi mà ấn nút enter trên bànn phím 
                ref.read(todoListProvider.notifier).add(value);
                newTodoController.clear();   // đưa giá trị của ô TextField về  "" 
              },
            ),
            const SizedBox(height: 42),
            const Toolbar(),     // Thanh công cụ để có thể chọn trạng thái của việc làm 
            if (todos.isNotEmpty) const Divider(height: 0),
            for (var i = 0; i < todos.length; i++) ...[     // Đây cách viết giải hết các View trong mảng ra bên ngoài 
              if (i > 0) const Divider(height: 0),
              Dismissible(   // Hiệu ứng vuốt sang trái hoặc sang phải để xoá việc cần làm khỏi danh sách
                key: ValueKey(todos[i].id),
                onDismissed: (_) {
                  ref.read(todoListProvider.notifier).remove(todos[i]);
                },
                child: ProviderScope(   // Cách cung cấp ProviderScope cho phần tử child của nó 
                  overrides: [
                    _currentTodo.overrideWithValue(todos[i]),
                  ],
                  child: const TodoItem(),  // View của từng Item việc làm 
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class Toolbar extends HookConsumerWidget {
  const Toolbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(todoListFilter); // Lắng nghe statee lựa chọn trạng thái việc làm trong Provider 

// Hàm quyết định màu của item lựa chọn trạng thái việc làm 
    Color? textColorFor(TodoListFilter value) {
      return filter == value ? Colors.blue : Colors.black;
    }

    return Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '${ref.watch(uncompletedTodosCount)} items left',   // Lắng nghe Provider đếm số lượng công việc chưa hoàn thành 
              overflow: TextOverflow.ellipsis,   // Nếu mà Text dài quá thì ...
            ),
          ),
          // Option hiện tất cả danh sách các công việc 
          Tooltip(
            key: allFilterKey,
            message: 'All todos',
            child: TextButton(
              onPressed: () =>
                  ref.read(todoListFilter.notifier).state = TodoListFilter.all,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor:
                    MaterialStateProperty.all(textColorFor(TodoListFilter.all)),
              ),
              child: const Text('All'),
            ),
          ),

          // Option hiện danh sách các công việc chưa hoàn thành 
          Tooltip(
            key: activeFilterKey,
            message: 'Only uncompleted todos',
            child: TextButton(
              onPressed: () => ref.read(todoListFilter.notifier).state =
                  TodoListFilter.active,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor: MaterialStateProperty.all(
                  textColorFor(TodoListFilter.active),
                ),
              ),
              child: const Text('Active'),
            ),
          ),
          // Option lựa chọn : danh sách các công việc đã hoàn thành 
          Tooltip(
            key: completedFilterKey,
            message: 'Only completed todos',
            child: TextButton(
              onPressed: () => ref.read(todoListFilter.notifier).state =
                  TodoListFilter.completed,    // Có thể thay đổi giá trị của State bằng cách gán lại giá trị trực tiếp ntn 
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor: MaterialStateProperty.all(     // foregroundColor thay đổi màu trực tiếp của chữ 
                  textColorFor(TodoListFilter.completed), 
                ),
              ),
              child: const Text('Completed'),
            ),
          ),
        ],
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'todos',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color.fromARGB(38, 47, 47, 247),
        fontSize: 100,
        fontWeight: FontWeight.w100,
        fontFamily: 'Helvetica Neue',
      ),
    );
  }
}



// Để có thể nhận được todo thông qua Provider chứ không phải thông qua constructor của TodoItem 
// Điều đó cho phép khởi tạo  TodoItem bằng từ khoá const 
// Điều này đảm bảo rằng  khi chúng ta thêm/ Xoá . Chính sửa việc ần làm chỉ những widget bị ảnh hưởng được xây dựng lại thay vì toàn bộ danh sách các mục 


final _currentTodo = Provider<Todo>((ref) => throw UnimplementedError());   // Hiểu đơn giản trước mắt là nếu k có thì đưa ra 1 lỗi 

class TodoItem extends HookConsumerWidget {
  const TodoItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = ref.watch(_currentTodo); 
    final itemFocusNode = useFocusNode(); // FocusNode sẽ sử dụng cho widget Focus 
    final itemIsFocused = useIsFocused(itemFocusNode);  // Biến kiểm tra itemFocusNode đó đã được Focus hay chưa 

    final textEditingController = useTextEditingController();  //TextEditingController trong thư viện flutter_hooks 
    final textFieldFocusNode = useFocusNode();   // FocusNode sử dụng cho ô TextField nếu đang là ô TextField 

    return Material(
      color: Colors.white,
      elevation: 6,
      child: Focus(    // Sử dụng widget Focus để có thể sử lý onTap của 1 item 
        focusNode: itemFocusNode,
        onFocusChange: (focused) {
          if (focused) {
            textEditingController.text = todo.description;
          } else {
            // Commit changes only when the textfield is unfocused, for performance
            ref
                .read(todoListProvider.notifier)
                .edit(id: todo.id, description: textEditingController.text);
          }
        },
        child: ListTile(
          onTap: () {
            itemFocusNode.requestFocus();   // Focus vào item vừa được chạm 
            textFieldFocusNode.requestFocus();   // Focus vào ô TextField vừa được tạo ra 
          },
          leading: Checkbox(
            value: todo.completed,
            onChanged: (value) =>
                ref.read(todoListProvider.notifier).toggle(todo.id),   // Bấm vào thì thay đổi giá trị của completed của todo có id là id 
          ),      // Bên trái của ListTile 
          title: itemIsFocused
              ? TextField(
                  autofocus: true,
                  focusNode: textFieldFocusNode,
                  controller: textEditingController,
                )
              : Text(todo.description),   // Nếu mà item đang được chọn thì hiển thị TextField ô nhập --- nếu không được chọn thì là ô Text bình thưởng hiển thị mô tả việc làm 
        ),
      ),
    );
  }
}

bool useIsFocused(FocusNode node) {
  final isFocused = useState(node.hasFocus);   // Đây là 1 biến của hàm 

  useEffect(
    () {
      // Đây là 1 hàm bình thường được viết ra để làm callback cho node.addListener 
      void listener() {
        isFocused.value = node.hasFocus;
      }

      node.addListener(listener);
      return () => node.removeListener(listener);  // dispose thì huỷ lắng nghe đi 
    },
    [node],   // Khi mà node thay đổi thì sẽ chạy lại callback của useEffect  
  );

  return isFocused.value;
}
