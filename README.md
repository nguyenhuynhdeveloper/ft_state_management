27/9/2022: Học về Quản lý state Bằng Bloc 


Có 2 trường phái sử dụng Bloc
1: Dùng cubit :UI Đẩy hàm nhận state
2: Dùng bloc : UI Đẩy events nhận state

Bloc bao gồm 1 số packages
bloc : Core bloc library 
flutter_bloc: Bloc cho flutter
angular_bloc: Bloc cho angular web 

#  https://bloclibrary.dev/#/coreconcepts
bản chất sâu sa của của bloc là sử dụng Stream của Dart - RX dart
Stream như 1 ống nước , và các data là nước chảy trong ống nước đó

a stream is a sequence of asynchronous data

cubit phơi bày ra các hàm để có thể kích hoạt sự thay đổi của state

state là đầu ra của cubit và đại diện cho một phần trạng thái của ứng dụng
Các thành phần giao diện người dùng có thể được thông báo về sự thay đổi state và render lại giao diện dựa theo state hiện tại 

có thể tạo 1 Stream bằng hàm async*

Stream<int> countStream(int max) async* {
  for (int i = 0; i < max; i++) {
    yield i;
  }
}

sử dụng async* có thể sử dụng yield : mỗi lần gặp yield là đẩy 1 giá trị ra khỏi luồng stream 

Có thể sử dụng Stream theo 1 số cách 
Nếu muốn trả về 1 tổng các 1 luồng stream các số nguyên thì có thể dùng return

Future<int> sumStream(Stream<int> stream) async {
  // stream ở đây là 1 Stream<int>  -> 1 luồng số nguyên -> 1 list số nguyên
  int sum = 0;
  await for (int value in stream) {
    // Vì Stream là async* 1 hàm bất đồng bộ nên hàm sumStream cũng phải là 1 hàm bất đồng bộ --> phải dùng await để hứng kết quả bất đồng bộ
    sum += value;
  }
  return sum;
}


We can put it all together like so:

void main() async {
  /// Initialize a stream of integers 0-9
  Stream<int> stream = countStream(10);

  /// Compute the sum of the stream of integers
  int sum = await sumStream(stream);

  /// Print the sum
  print(sum); // 45
}


Cubit là class kế thừa từ BlocBase và có thể quản lý bất kỳ loại state nào 

Cubit phơi ra các hàm để UI gọi ==> thay đổi State 


Bước 1 tạo 1 Cubit 

class NameCubit extends Cubit<int> {
NameCubit(int initialState) : super(initialState);  //initialState Là giá trị khởi tạo của state thường để là 1 đối tượng Kế thừa từ class có method tự viết là copyWith()
}

Ví dụ : cubit tăng giảm 1 số
class CounterCubit extends Cubit<int> {
CounterCubit() : super(0);
}

//Tạo ra 1 cubit từ class Cubit

final cubitA = CounterCubit(0); // state starts at 0
final cubitB = CounterCubit(10); // state starts at 10

B2: Thay đổi state
Cubit có khả năng output ra state bằng emit

class CounterCubit extends Cubit<int> {
CounterCubit() : super(0);

void increment() => emit(state + 1);   //Hàm increment() chính là để UI gọi dùng
void decrement() => emit(state - 1);
}


B3 : Tạo Khai báo ra 1 Bloc và phạm vi bao phủ của nó

void main() => runApp(CounterApp());

class CounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => CounterCubit(),
        child: CounterPage(),
      ),
    );
  }
}



B4: Ở UI gọi cubit và sử dụng thay đổi state- nhận state
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: BlocBuilder<CounterCubit, int>(
        //Tham số thứ 2 của BlocBuilder chính là state
        builder: (context, count) => Center(
            child: Text(
                '$count')), //count Đây chính là State dạng int của cubit CounterCubit
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => context.read<CounterCubit>().increment(),
          ),
          const SizedBox(height: 4),
          FloatingActionButton(
            child: const Icon(Icons.remove),
            onPressed: () => context.read<CounterCubit>().decrement(),
          ),
        ],
      ),
    );
  }
}



# 9/10/2022
Bloc là 1 tập hợp các thư viện bloc-core bloc library 
Flutter_bloc : Sử dụng cho nền tảng Flutter
Angular_bloc: Sử dụng cho nền tảng front end Angular 


-----> Flutter Bloc bên trong có 
BlocBuilder
BlocSelector
BLocProvider
MultiBlocProvider
BlocListener
MultiBlocListener
BlocConsumer
RepositoryProvider
MultiRepositoryProvider

# demo_ft_bloc




