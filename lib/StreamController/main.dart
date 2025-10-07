import 'package:flutter/material.dart';
import 'dart:async';


void main() {
  runApp(const MyApp());
}

// Đây là 1 ví dụ Bloc bình thường nhưng có sử dụng StreamController

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC Counter: Core vs RxDart',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const CounterPage(),
    );
  }
}

// Tao class Bloc để quản lý state
class CounterBloc {
  int _count = 0;  // Biến riêng biệt để đưa vào đường ống dữ liệu để thay đổi và hiển thị

  final _controller = StreamController<int>();

  Stream<int> get stream => _controller.stream;  // Đưa cái stream này ra ngoài để ui sử dụng

  void increment() {
    _controller.add(++_count);  // Đưa sự thay đổi giá trị vào trong đường ống Stream
  }

  void dispose() => _controller.close();
}

// Widget màn hình sử dụng data của đường ống StreamController
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});
  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  late final CounterBloc bloc;   // Tạo ra biến bloc 

  @override
  void initState() {
    super.initState();
    bloc = CounterBloc();  // Gán giá trị cho biến bloc
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StreamController Demo')),
      body: Center(
        // Sủ dụng StreamBuilder để vẽ UI từ data qua snapshot data
        child: StreamBuilder<int>(
          stream: bloc.stream,
          initialData: 0, // hiển thị trước khi có sự kiện đầu tiên
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text('Lỗi: ${snapshot.error}');
            return Text(
              'Count: ${snapshot.data}',
              style: const TextStyle(fontSize: 32),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: bloc.increment,  // Chạy hàm bên bloc để thay đổi giá trị trong StreamController
        child: const Icon(Icons.add),
      ),
    );
  }
}
