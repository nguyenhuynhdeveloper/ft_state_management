import 'package:demo_ft_bloc/demo_cubit/CounterApp.dart';
import 'package:demo_ft_bloc/demo_cubit_bloc/cubit_bloc_screen.dart';
import 'package:demo_ft_bloc/demo_cubit/CounterApp.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    // home: CubitBlocScreen(), // /MaterialApp thì có home
    home: CounterApp(), 
  ));
}






// https://pub.dev/packages/flutter_bloc

/**
 * 10/10/2022: Bloc_Flutter
 * 
 * Cubit được kế thừa từ BlocBase 
 * Dựa vào hàm để thay đổi state
 * cubit yêu cầu 1 state initial state : Sẽ là state mà trước khi lần đầu tiên emit được gọi 
 * state của cubit có thể truy cập thông qua state getter và cập nhật bằng cách emit ra 1 state mới 
 * 
 * Observing a cubit : Quan sát cubit 
 * BlocObserver có thể được sử dụng để quan sát tất cả các cubit
 * 
 * Bloc được kế thừa từ BlocBase
 * Dựa vào sự kiện để thay đổi state ( giống giống redux)
 * bloc nhận sự kiện và thay đổi state tương ứng với sự kiện 
 * Các sự kiện được phát sẽ kích hoạt onEvent và làm thay đổi state
 * Sau đó các sự kiện được điều chỉnh thông qua 1 eventTransformer 
 * Theo mặc định mỗi sự kiện được sử lý đồng thời nhưng một EventTransformer tuỳ chỉnh có thể được cung cấp để điều khiển luồng sự kiện đến 
 * Tất cả các EventHandlers đã đăng ký cho loại sự kiện đó sau đó sẽ được gọi cùng với sự kiện đến 
 * Mỗi EventHandler chịu trách nhiệm tạo ra không hoặc nhiều state để  phản ứng với sự kiện 
 * Cuối cùng onTransition được gọi ngay trước khi state được cập nhật và chứa state hiện tại + sự kiện + state tiếp theo
 * 
 * Creating a Bloc
 * 
/// The events which `CounterBloc` will react to.
abstract class CounterEvent {}

/// Notifies bloc to increment state.
class CounterIncrementPressed extends CounterEvent {}

/// A `CounterBloc` which handles converting `CounterEvent`s into `int`s.
class CounterBloc extends Bloc<CounterEvent, int> {
  /// The initial state of the `CounterBloc` is 0.
  CounterBloc() : super(0) {
    /// When a `CounterIncrementPressed` event is added,
    /// the current `state` of the bloc is accessed via the `state` property
    /// and a new state is emitted via `emit`.
    on<CounterIncrementPressed>((event, emit) => emit(state + 1));
  }
}

Using a Bloc
Future<void> main() async {
  /// Create a `CounterBloc` instance.
  final bloc = CounterBloc();

  /// Access the state of the `bloc` via `state`.
  print(bloc.state); // 0

  /// Interact with the `bloc` to trigger `state` changes.
  bloc.add(CounterIncrementPressed());

  /// Wait for next iteration of the event-loop
  /// to ensure event has been processed.
  await Future.delayed(Duration.zero);

  /// Access the new `state`.
  print(bloc.state); // 1

  /// Close the `bloc` when it is no longer needed.
  await bloc.close();
}

Observing a Bloc
Giống như cubit vì đều được extends từ BlocBase, onChange và onError có thể được overide trong Bloc
Hơn cubit , thì bloc có thể ghi đè onEvent và onTransition 
onEvents được gọi khi bất kỳ khi nào một sự kiện được thêm vào bloc 
onTransition tương tự như onChange, tuy nhiên nó chứa sự kiện kích hoạt + state curent + state next
BlocObserver có thể sử dụng để quan sát tất cả các bloc



//Khởi tạo nơi chứa cubit
Đặt cubit trong một BlocProvider tại một widget cha
Trong ví dụ này chúng ta sẽ đặt Cubit vào BlocProvider, bloc BlocProvider này trong MyApp widget:
BlocProvider là một Widget dùng để xử lý các cubit, lưu trữ các giá trị trong Cubit vào Provider.

counter_cubit.dart : Định nghĩa xây dựng 1 cubit 

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}

main.dart : Khởi tạo khai báo cubit
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

counter_page.dart : Sử dụng cubit 
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: BlocBuilder<CounterCubit, int>(
        builder: (context, count) => Center(child: Text('$count')),
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
//Sử dụng cubit
Tạo View để sử dụng Cubit
Tạo folder views và tạo file : counter_page.dart để sử dụng cubit, hiển thị và tương tác trên view
BlocBuilder là một Widget hỗ trợ việc build giao diện và cung cấp giá trị được lưu trong BlocProvider mà lấy được từ Cubit.
Biến count chính là giá trị lưu trữ trong Cubit mà đặt vào Provider. Giá trị này sẽ được cập nhật khi các button được tương tác :
 */

/**
 * Ngày 12/10/2022
 -------------BlocBuilder : Để sử dụng sự thay đổi state render lại View nhờ hàm builder 
 //---------- Bất cứ state nào thay đổi đều render lại hàm builder
 BlocBuilder có hàm builder để xấy dựng widget UI theo state mới 
 BlocBuilder rất giống với StreamBuilder nhưng có API đơn giản hơn để giảm số lượng mã soạn sẵn cần thiết
 builder là 1 hàm thuần tuý trả ra các widget theo state của state, state thay đổi là hàm builder được gọi lại 
 Xem BlocListener nếu bạn muốn "làm" bất cứ điều gì để đáp ứng với các thay đổi state, chẳng hạn như điều hướng, hiển thị hộp thoại, v.v
 Nếu tham số bloc bị bỏ qua, BlocBuilder sẽ tự động thực hiện tra cứu bằng BlocProvider và BuildContext hiện tại.

 BlocBuilder<BlocA, BlocAState>(
  builder: (context, state) {
    // return widget here based on BlocA's state
  }
)

Chỉ chỉ định Bloc nếu bạn muốn cung cấp một Bloc sẽ nằm trong phạm vi một widget con duy nhất
 và không thể truy cập được thông qua BlocProvider mẹ và BuildContext hiện tại

 BlocBuilder<BlocA, BlocAState>(
  bloc: blocA, // provide the local bloc instance
  builder: (context, state) {
    // return widget here based on BlocA's state
  }
)

Để kiểm soát chi tiết khi nào builder function  được gọi là builderWhen có thể được cung cấp. 
builderWhen lấy state Bloc trước đó và state Bloc hiện tại và trả về một boolean
Nếu builderWhen trả về true, thì builder sẽ được gọi với state và widget sẽ re render lại
builder trả về fasle thì builder sẽ không được render lại 

BlocBuilder<BlocA, BlocAState>(
  buildWhen: (previousState, state) {
    // return true/false to determine whether or not
    // to rebuild the widget with state
  },
  builder: (context, state) {
    // return widget here based on BlocA's state
  }
)
*/

/**------BlocSelector : tương tự như BlocBuilder nhưng cho phép chọn --------> State nào thay đổi  thì hàm builder mới render lại
 bằng cách chọn một giá trị mới dựa trên state bloc hiện tại
 Các builder không cần thiết bị ngăn chặn nếu state đã chọn không thay đổi.
 Nếu tham số bloc bị bỏ qua,
  BlocSelector sẽ tự động thực hiện tra cứu bằng cách sử dụng BlocProvider và BuildContext hiện tại.
  ---Chỉ 1 state được chọn trong selector thay đổi thì hàm builder mới render lại

  BlocSelector<BlocA, BlocAState, SelectedState>(
  selector: (state) {
    // return selected state based on the provided state.
  },
  builder: (context, state) {
    // return widget here based on the selected state.
  },
)
 */

/**-------BlocProvider-------Để khởi tạo - khai báo -Bloc

 BlocProvider là một widget Flutter cung cấp một bloc cho các con của nó thông qua BlocProvider.of<T>(context)
 Nó được sử dụng như một widget chèn phụ thuộc (DI) 
 để một thể hiện duy nhất của một bloc có thể được cung cấp cho nhiều widget trong một cây con.
 Trong hầu hết các trường hợp, BlocProvider nên được sử dụng để tạo các bloc mới sẽ được cung cấp cho phần còn lại của cây con.
Trong trường hợp này, vì BlocProvider chịu trách nhiệm tạo bloc nên nó sẽ tự động xử lý việc đóng nó.

BlocProvider(
  create: (BuildContext context) => BlocA(),
  child: ChildA(),
);
Theo mặc định, BlocProvider sẽ tạo một bloc lazily, 
có nghĩa là việc tạo sẽ được thực thi khi bloc được tra cứu qua BlocProvider.of <BlocA> (context).
Để ghi đè hành vi này và buộc tạo phải chạy ngay lập tức--- tạo khai báo ngay lập tức, lazy có thể được đặt thành sai.

BlocProvider(
  lazy: false,
  create: (BuildContext context) => BlocA(),
  child: ChildA(),
);

BlocProvider.value:  Trong một số trường hợp, BlocProvider có thể được sử dụng để cung cấp một bloc hiện có cho một phần mới của cây widget con.
Điều này sẽ được sử dụng phổ biến nhất khi một bloc hiện có cần được cung cấp cho một tuyến đường mới.
 Trong trường hợp này, BlocProvider sẽ không tự động đóng bloc vì nó không tạo nó.

 BlocProvider.value(
  value: BlocProvider.of<BlocA>(context),
  child: ScreenA(),
);

thì từ ChildA hoặc ScreenA, chúng ta có thể truy xuất BlocA để thay đổi giá trị state  bằng

// with extensions
context.read<BlocA>();

// without extensions
BlocProvider.of<BlocA>(context);

Cách trên dẫn đến việc tra cứu một lần và widget con sẽ không được thông báo về các thay đổi.

Để truy xuất phiên bản và đăng ký các thay đổi state tiếp theo, hãy sử dụng:
// with extensions
context.watch<BlocA>();

// without extensions
BlocProvider.of<BlocA>(context, listen: true);

Ngoài ra, context.select có thể được sử dụng để truy xuất một phần của state và chỉ phản ứng với các thay đổi khi phần được chọn thay đổi.
final isPositive = context.select((CounterBloc b) => b.state >= 0);

Đoạn mã trên sẽ chỉ xây dựng lại nếu state của CounterBloc thay đổi từ tích cực sang tiêu cực hoặc ngược lại và có chức năng giống hệt như sử dụng BlocSelector
 */


/**--------MultiBlocProvider-------------
 Giúp hợp nhất nhiều BlocProvider lại thành 1
 Giúp cải thiện khả năng lấy state và kết hợp nhiều BlocProviders.

 Bằng cách sử dụng MultiBlocProvider, chúng ta có thể đi từ:
 BlocProvider<BlocA>(
  create: (BuildContext context) => BlocA(),
  child: BlocProvider<BlocB>(
    create: (BuildContext context) => BlocB(),
    child: BlocProvider<BlocC>(
      create: (BuildContext context) => BlocC(),
      child: ChildA(),
    )
  )
)

MultiBlocProvider(
  providers: [
    BlocProvider<BlocA>(
      create: (BuildContext context) => BlocA(),
    ),
    BlocProvider<BlocB>(
      create: (BuildContext context) => BlocB(),
    ),
    BlocProvider<BlocC>(
      create: (BuildContext context) => BlocC(),
    ),
  ],
  child: ChildA(),
)
 */

/**-----------------BlocListener  :Sử dụng sự thay đổi của state để thực hiện logic : điều hướng , đóng mở dialog, đóng mở snackBar....
BlocListener có 1listener lắng nghe được sự thay đổi của state đã lựa chọn và thực thi các hành đông
còn child không có tác dụng gì
Nó nên được sử dụng cho các chức năng cần phải thực hiện một lần cho mỗi thay đổi state như điều hướng, hiển thị SnackBar, hiển thị Hộp thoại, v.v.
listener chỉ được gọi một lần cho mỗi thay đổi state (KHÔNG bao gồm state ban đầu) không giống như builder trong BlocBuilder và là một hàm void
Nếu tham số bloc bị bỏ qua, BlocListener sẽ tự động thực hiện tra cứu bằng cách sử dụng BlocProvider và BuildContext hiện tại.

BlocListener<BlocA, BlocAState>(
  listener: (context, state) {
    // do stuff here based on BlocA's state -- thực hiện công việc ở đây dựa theo trạng thái của BlocA
  },
  child: Container(),
)

Chỉ chỉ định bloc nếu bạn muốn cung cấp một bloc không thể truy cập được thông qua BlocProvider và BuildContex hiện tại

BlocListener<BlocA, BlocAState>(
  bloc: blocA,
  listener: (context, state) {
    // do stuff here based on BlocA's state
  }
)

Để kiểm soát listener khi nào state thay đổi như thế nào mới được chạy lại thì dùng listenWhen 
listenWhen lấy state bloc trước đó và state bloc hiện tại và trả về một boolean.
Nếu listenWhen trả về true, thì listener sẽ được gọi với state.
Nếu listenWhen trả về false, thì listener sẽ không được gọi với state.


 BlocListener<BlocA, BlocAState>(
  listenWhen: (previousState, state) {
    // return true/false to determine whether or not
    // to call listener with state
  },
  listener: (context, state) {
    // do stuff here based on BlocA's state
  },
  child: Container(),   // BlocListener có tham số child để có thể vẽ View trong đó 
)
 */





/**-------------MultiBLocListener--------------
 widget giúp hợp nhất nhiều BlocListener lại thành 1
 Giúp cải thiệt khả năng đọc và loại bỏ sự phải lồng nhiều BlocListener
 Bằng cách sử dụng MultiBlocListener, chúng ta có thể đi từ:


 BlocListener<BlocA, BlocAState>(
  listener: (context, state) {},
  child: BlocListener<BlocB, BlocBState>(
    listener: (context, state) {},
    child: BlocListener<BlocC, BlocCState>(
      listener: (context, state) {},
      child: ChildA(),
    ),
  ),
)

--------->

MultiBlocListener(
  listeners: [
    BlocListener<BlocA, BlocAState>(
      listener: (context, state) {},
    ),
    BlocListener<BlocB, BlocBState>(
      listener: (context, state) {},
    ),
    BlocListener<BlocC, BlocCState>(
      listener: (context, state) {},
    ),
  ],
  child: ChildA(),
)
 */


/**----------BLocConsumer------------------
 Giúp kết hợp cả builder để render lại view mới và listener để sử lý logic với state mới
 BlocConsumer = BlocBuilder lồng với BlocListener 
 BlocConsumer chỉ nên được sử dụng khi cần thiết cả xây dựng lại giao diện người dùng và thực hiện các phản ứng khác đối với các thay đổi state trong bloc.
 BlocConsumer lấy BlocWidgetBuilder và BlocWidgetListener bắt buộc 
 và một bloc tùy chọn, BlocBuilderCondition và BlocListenerCondition

Nếu tham số bloc bị bỏ qua, BlocConsumer sẽ tự động thực hiện tra cứu bằng BlocProvider và BuildContext hiện tại

BlocConsumer<BlocA, BlocAState>(
  listener: (context, state) {
    // do stuff here based on BlocA's state
  },
  builder: (context, state) {
    // return widget here based on BlocA's state
  }
)


Một tùy chọn listenWhen  và buildWhen có thể được triển khai để kiểm soát chi tiết hơn khi nào listener và builder được gọi.
ListenWhen và buildWhen sẽ được gọi vào mỗi lần thay đổi state bloc. Chúng đều lấy state trước đó và state hiện tại và phải trả về một bool xác định xem hàm builder và / hoặc listener có được gọi hay không.

state trước đó sẽ được khởi tạo thành state của bloc khi BlocConsumer được khởi tạo. listenWhen và buildWhen là tùy chọn và nếu chúng không được triển khai, chúng sẽ mặc định là true.

BlocConsumer<BlocA, BlocAState>(
  listenWhen: (previous, current) {
    // return true/false to determine whether or not
    // to invoke listener with state
  },
  listener: (context, state) {
    // do stuff here based on BlocA's state
  },
  buildWhen: (previous, current) {
    // return true/false to determine whether or not
    // to rebuild the widget with state
  },
  builder: (context, state) {
    // return widget here based on BlocA's state
  }
)

 */


/**------------RepositoryProvider---------------
 RepositoryProvider là một widget Flutter cung cấp một kho lưu trữ cho các con của nó thông qua RepositoryProvider.of <T> (context)
 Nó được sử dụng như một widget bổ sung phụ thuộc (DI) để một phiên bản kho lưu trữ có thể được cung cấp cho nhiều widget con trong một cây con
 BlocProvider nên được sử dụng để cung cấp các bloc trong khi RepositoryProvider chỉ nên được sử dụng cho các kho lưu trữ.

 RepositoryProvider(
  create: (context) => RepositoryA(),
  child: ChildA(),
);

và sau đó ChildA có thể truy xuất dữ liệu ở RepositoryA
// with extensions
context.read<RepositoryA>();

// without extensions
RepositoryProvider.of<RepositoryA>(context)


 */

/**--------MultiRepositoryProvider
 giúp hợp nhất nhiều RepositoryProvider lại thành 1
 Cải thiện khả năng đọc và loại bỏ việc lồng nhiều RepositoryProvider với nhau ,
 Sử dụng MultiRepositoryProvider chúng ta có thể thay thế

 RepositoryProvider<RepositoryA>(
  create: (context) => RepositoryA(),
  child: RepositoryProvider<RepositoryB>(
    create: (context) => RepositoryB(),
    child: RepositoryProvider<RepositoryC>(
      create: (context) => RepositoryC(),
      child: ChildA(),
    )
  )
)
 ---------->
MultiRepositoryProvider(
  providers: [
    RepositoryProvider<RepositoryA>(
      create: (context) => RepositoryA(),
    ),
    RepositoryProvider<RepositoryB>(
      create: (context) => RepositoryB(),
    ),
    RepositoryProvider<RepositoryC>(
      create: (context) => RepositoryC(),
    ),
  ],
  child: ChildA(),
)
 */