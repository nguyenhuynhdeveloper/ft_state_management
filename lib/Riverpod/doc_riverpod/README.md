## Providers

Nhà cung cấp là phần quan trọng nhất của ứng dụng Riverpod. Nhà cung cấp là một đối tượng đóng gói một phần trạng thái và cho phép lắng nghe trạng thái đó.

## Why use providers?

Cho phép dễ dàng truy cập trạng thái đó ở nhiều vị trí. Các nhà cung cấp là sự thay thế hoàn toàn cho các mẫu như Singletons, Bộ định vị dịch vụ, Dependency Insert hoặc InheritedWidge

Đơn giản hoá việc kết hợp state này với state khác , Giúp hợp nhất nhiều state lại thành 1

## Creating a provider

Các nhà cung cấp có nhiều biến thể, nhưng tất cả đều hoạt động theo cùng một cách. Cách sử dụng phổ biến nhất là khai báo chúng dưới dạng hằng số toàn cục như sau:

final myProvider = Provider((ref) {
return MyValue();
});

Các nhà cung cấp là hoàn toàn bất biến. Khai báo một nhà cung cấp không khác gì khai báo một hàm và các nhà cung cấp có thể kiểm tra và bảo trì được.

final myProvider , phần khai báo một biến. Biến này là những gì chúng tôi sẽ sử dụng trong tương lai để đọc trạng thái của nhà cung cấp của chúng tôi. Các nhà cung cấp phải luôn là final .

Provider là basic nhất trong tất cả providers , nó cung cấp 1 giá trị không bao giờ thay đổi , để có thể thay đổi sử dụng StreamProvider hoặc StateNotifierProvider

function luôn nhận 1 object ref là tham số , Giúp đọc giá trị của các Provider khác

Có thể tạo bao nhiêu Provider tuỳ thích , RiverPod cho phép tạo nhiều provider cùng loại

### Different Types of Providers

Provider : Return any type
StateProvider : Return any type

FutureProvider : Return Future của any type : Đa số result từ Call API

StreamProvider : Return Stream của any type : Đa số result từ call API
StateNotifierProvider : Returns 1 subclass của StateNotifier : Thường thay đổi giá trị bên trong giao diện

ChangeNotifierProvider : Returns 1 subclass của StateNotifier : 1 object state phức tạp yêu cầu thay đổi được

ChangeNotifierProvider : Khuyến cáo không sử dụng

### Provider Modifiers

có các phần extra functionalities để thêm các tính năng mới

final myAutoDisposeProvider = StateProvider.autoDispose<int>((ref) => 0);
final myFamilyProvider = Provider.family<String, int>((ref, id) => '$id');

Hiện tại có 2 công cụ có sẵn
.autoDispose : Sẽ huỷ Provider khi không được lắng nghe nữa
.family : Cho Phép provider nhận các tham số tử bên ngoài

provider có thể nhận nhiều mulltiple modifiers

final userProvider = FutureProvider.autoDispose.family<User,int>((ref, userId) async {
return fetchUser(userId);
})

######## Reading a Provider

### Obtaining a "ref" object

Để có thể đọc được giá trị của provider ta cần lấy được ref object trước
ref cho phép tương tác với Provider từ widget hoặc từ provider khác

# ######## Obtaining a "ref" from a provider

tất cả các provider nhận ref như 1 tham só

final provider = Provider((ref) {
// use ref to obtain other providers: Sử dụng ref để nhận được các other provider
final repository = ref.watch(repositoryProvider);

return SomeValue(repository);
})

Trường hợp sử dụng phổ biến nhất là chuyển ref của nhà cung cấp tới StateNotifier

final counterProvider = StateNotifierProvider<Counter, int>((ref) {
return Counter(ref);
});

class Counter extends StateNotifier<int> {
Counter(this.ref): super(0);

final Ref ref;

void increment() {
// Counter can use the "ref" to read other providers :
// Counter có thể sử dụng ref để đọc các other providers
final repository = ref.read(repositoryProvider);
repository.post('...');
}
}

Làm như vậy cho phép lớp Counter của chúng tôi đọc các nhà cung cấp.

# ######## Obtaining a "ref" from a widget

Các widget tự nhiên không có tham số ref , nhưng Riverpod cung cấp nhiều giải pháp nhận ref từ widgets

# Extending ConsumerWidget instead of StatelessWidget

Cách phổ biến nhất để có được giới thiệu trong cây tiện ích là thay thế StatelessWidget bằng ConsumerWidget.

ConsumerWidget có cách sử dụng giống hệt StatelessWidget, với điểm khác biệt duy nhất là nó có một tham số bổ sung trong phương thức xây dựng của nó: đối tượng "ref".

// Đây là 1 ví dụ điển hình

class HomeView extends ConsumerWidget {
const HomeView({Key? key}): super(key: key);

@override
Widget build(BuildContext context, WidgetRef ref) {
// use ref to listen to a provider
final counter = ref.watch(counterProvider);
return Text('$counter');
}
}

# Extending ConsumerStatefulWidget+ConsumerState instead of StatefulWidget+State

Tương tự ConsumerWidget : ConsumerStatefulWidget + ConsumerState === hơn StatefulWidget + State ở chỗ có ref

Lần này, "ref" không được truyền dưới dạng tham số của phương thức xây dựng mà là một thuộc tính của đối tượng ConsumerState:

class HomeView extends ConsumerStatefulWidget {
const HomeView({Key? key}): super(key: key);

@override
HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
@override
void initState() {
super.initState();
// "ref" can be used in all life-cycles of a StatefulWidget. : ref có thể sử dụng ở tất cả các vòng đời của StatefulWidget
ref.read(counterProvider);
}

@override
Widget build(BuildContext context) {
// We can also use "ref" to listen to a provider inside the build method
// Chúng ta cũng có thể sử dụng ref để lắng nghe provider bên trong build method
final counter = ref.watch(counterProvider);
return Text('$counter');
}
}

# Extending HookConsumerWidget instead of HookWidget

tuỳ chọn này nếu sử dụng flutter_hooks Phải sử dụng HookConsumerWidget chứ không sử dụng ConsumerWidget được

Gói hooks_riverpod hiển thị một tiện ích mới có tên HookConsumerWidget. HookConsumerWidget hoạt động như cả ConsumerWidget và HookWidget.

Điều này cho phép widget vừa lắng nghe provider và vừa sử dụng hooks

class HomeView extends HookConsumerWidget {
const HomeView({Key? key}): super(key: key);

@override
Widget build(BuildContext context, WidgetRef ref) {
// HookConsumerWidget allows using hooks inside the build method
// HookconsumerWidget cho phép sử dụng hooks bên trong build method
final state = useState(0);

    // We can also use the ref parameter to listen to providers.
    // Chúng ta sử dụng ref tham số để lắng nghe providers

    final counter = ref.watch(counterProvider);
    return Text('$counter');

}
}

# Extending StatefulHookConsumerWidget instead of HookWidget

Tuỳ chọn người dùng sử dụng flutter_hooks , những ai cần sử dụng StatefulWidget với hooks

class HomeView extends StatefulHookconsumerWidget {
const HomeView ({Key? key}) : super(key: key);
@overridde
HomeViewState createState() => HomeViewStae();
}

class HomeViewState extends ConsumerState<HomeView> {
@override
void initState() {
super.initState()
// ref có thể sử dụng ở tất cả cá vòng đời của StatefulWidget
ref.read(counterProvider);;
}

    @override
    Widget build(BuildContext context ) {
        // Với HookConsumerWidget , chúng ta có thể sử dụng hooks bên trong build method
        final state = useState(0);

        //Chúng ta có thể sử dụng ref để lắng nghe Provider bên trong build method
        final counter = ref.watch(counterProvider);
        return Text('$counter);
    }

}

# Consumer and HookConsumer widgets

Cách cuối cùng để có được "ref" bên trong các widget là dựa vào Consumer/HookConsumer.

Các class này là các widget có thể sử dụng để nhận ref từ builder callback . với các thuộc tính như ConsumerWidget/ HookConsumerWidget

Tiện ích này là cách để có được ref mà không càn define class

Scaffold(
body: HookConsumer(
builder: (context, ref, child) {
// Like HookConsumerWidget, we can use hooks inside the builder
// Với HookConsumerWidget , chúng ta có thể sử dụng hook bên trong builder
final state = useState(0);

      // We can also use the ref parameter to listen to providers.
      final counter = ref.watch(counterProvider);
      return Text('$counter');
    },

),
);

###### Using ref to interact with providers

Có 3 cách chính để sử dụng ref

ref.watch : Lấy giá trị của provider và lắng nghe các thay đổi, chẳng hạn state thay đổi , đều này sẽ xây dựng lại widget

ref.listen : Lắng nghe provider , để thực hiện 1 hành động như điều hướng đến 1 trang mới hoặc hiển thị 1 modal khi provider thay đổi

ref.read : Lấy giá trị của provider trong khi bỏ qua các thay đổi , Điều này hữu ích khi cần giá trị của 1 Providder trong 1 sự kiện chẳng hặn như khi onClick

Bất cứ khi nào có thể, hãy ưu tiên sử dụng ref.watch hơn ref.read hoặc ref.listen để triển khai một tính năng.

Bằng cách dựa vào ref.watch, ứng dụng của bạn trở nên vừa phản ứng vừa khai báo, điều này giúp ứng dụng dễ bảo trì hơn.

## Using ref.watch to observe a provider

ref.watch có thể sử dụng bên trong build method của widget hoặc bên trong body của provider để widget/provider có thể lắng nghe provider

Ví dụ: nhà cung cấp có thể sử dụng ref.watch để kết hợp nhiều nhà cung cấp thành một giá trị mới.

Một ví dụ sẽ lọc danh sách việc cần làm. Chúng ta có thể có hai nhà cung cấp:
filterTypeProvider, nhà cung cấp hiển thị loại bộ lọc hiện tại (không có, chỉ hiển thị các tác vụ đã hoàn thành, ...)
todosProvider, nhà cung cấp hiển thị toàn bộ danh sách nhiệm vụ

Và bằng cách sử dụng ref.watch, chúng tôi có thể tạo nhà cung cấp thứ ba kết hợp cả hai nhà cung cấp để tạo danh sách nhiệm vụ được lọc:

final filterTypeProvider = StateProvider<FilterType>((ref) => FilterType.none);
final todosProvider = StateNotifierProvider<TodoList, List<Todo>>((ref) => TodoList());

final filteredTodoListProvider = Provider((ref) {
// obtains both the filter and the list of todos
final FilterType filter = ref.watch(filterTypeProvider);
final List<Todo> todos = ref.watch(todosProvider);

switch (filter) {
case FilterType.completed:
// return the completed list of todos
return todos.where((todo) => todo.isCompleted).toList();
case FilterType.none:
// returns the unfiltered list of todos
return todos;
}
});

Với mã này, filterTodoListProvider hiện hiển thị danh sách tác vụ đã lọc.

Danh sách đã lọc cũng sẽ tự động cập nhật nếu bộ lọc hoặc danh sách nhiệm vụ thay đổi

Đồng thời, danh sách đã lọc sẽ không được tính toán lại nếu cả bộ lọc và danh sách tác vụ đều không thay đổi

Tương tự, một tiện ích có thể sử dụng ref.watch để hiển thị nội dung từ nhà cung cấp và cập nhật giao diện người dùng bất cứ khi nào nội dung đó thay đổi:

final counterProvider = StateProvider((ref) => 0);

class HomeView extends ConsumerWidget {
const HomeView({Key? key}): super(key: key);

@override
Widget build(BuildContext context, WidgetRef ref) {
// use ref to listen to a provider
final counter = ref.watch(counterProvider);

    return Text('$counter');

}
}

Lắng nghe 1 provider cái đang quản lý count , và nếu count thay đổi , Widget sẽ được rebuild lại và UI sẽ update hiển thị ra giá trị mới

Method watch không được gọi 1 cách không đồng bộ , giống như bên trong 1 onPressed của ElevateButton , nó không nên được sử dụng bên trong initState và các vòng đời khác của State

Trong những trường hợp đó, hãy cân nhắc sử dụng ref.read thay thế.
