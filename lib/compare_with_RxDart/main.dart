import 'package:flutter/material.dart';
import 'core_bloc/counter_bloc_core.dart';
import 'rxdart_bloc/counter_bloc_rx.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC Counter: Core vs RxDart',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const HomeTabs(),
    );
  }
}

// Widget chứa 2 màn hình -- TabBarView
class HomeTabs extends StatefulWidget {
  const HomeTabs({super.key});
  @override
  State<HomeTabs> createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> with TickerProviderStateMixin {
  late final TabController _tab;  // Controller điểu khiển TabBarView
  late final CounterBlocCore coreBloc;   // Bloc của StreamController
  late final CounterBlocRx   rxBloc;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    coreBloc = CounterBlocCore();  // Tạo ra đối tượng bloc của Bloc StreamController
    rxBloc   = CounterBlocRx();
  }

  @override
  void dispose() {
    _tab.dispose();
    coreBloc.dispose();
    rxBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('So sánh StreamController vs RxDart'),  // Tên của màn hình Scaffold
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Core StreamController'),
            Tab(text: 'RxDart BehaviorSubject'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _CounterCorePage(bloc: coreBloc),
          _CounterRxPage(bloc: rxBloc),
        ],
      ),
    );
  }
}

/// Màn hình sử dụng core (StreamController): không debounce, mapEventToState thủ công.
class _CounterCorePage extends StatelessWidget {
  final CounterBlocCore bloc;
  const _CounterCorePage({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return _CounterScaffold(
      title: 'Core StreamController',
      stream: bloc.stream,
      onInc: bloc.increment,
      onDec: bloc.decrement,
      onReset: bloc.reset,
      extraNote: '• Single/broadcast tuỳ bạn tạo\n'
          '• Tự giữ _count và map event → state',
    );
  }
}

/// Màn hình Rx (RxDart): BehaviorSubject giữ last value, có debounceTime demo.
class _CounterRxPage extends StatelessWidget {
  final CounterBlocRx bloc;
  const _CounterRxPage({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return _CounterScaffold(
      title: 'RxDart BehaviorSubject',
      stream: bloc.stream,
      onInc: bloc.increment,
      onDec: bloc.decrement,
      onReset: bloc.reset,
      extraNote: '• BehaviorSubject giữ value hiện tại\n'
          '• debounceTime(150ms) trên luồng sự kiện\n'
          '• Dễ mở rộng với scan/combineLatest/switchMap...',
    );
  }
}

/// Widget khung dùng chung cho 2 màn so sánh
class _CounterScaffold extends StatelessWidget {
  final String title;
  final Stream<int> stream;
  final VoidCallback onInc;
  final VoidCallback onDec;
  final VoidCallback onReset;
  final String extraNote;

  const _CounterScaffold({
    required this.title,
    required this.stream,
    required this.onInc,
    required this.onDec,
    required this.onReset,
    required this.extraNote,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        // Phần UI vẽ từ data của luồng Stream
        StreamBuilder<int>(
          stream: stream,
          initialData: 0,
          builder: (context, snapshot) {  // snapshot chính là 1 map dữ liệu trong stream
            if (snapshot.hasError) {
              return Text('Lỗi: ${snapshot.error}', style: const TextStyle(color: Colors.red));
            }
            final value = snapshot.data ?? 0;
            return Text('$value', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold));
          },
        ),
        const SizedBox(height: 24),

        // Phần các button tương tác
        Wrap(
          spacing: 12,
          children: [
            ElevatedButton.icon(onPressed: onInc, icon: const Icon(Icons.add), label: const Text('Increment')),
            ElevatedButton.icon(onPressed: onDec, icon: const Icon(Icons.remove), label: const Text('Decrement')),
            OutlinedButton.icon(onPressed: onReset, icon: const Icon(Icons.refresh), label: const Text('Reset')),
          ],
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            extraNote,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
          ),
        ),
        const SizedBox(height: 12),
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'Tip: Ở tab RxDart, thử bấm nút + thật nhanh liên tục. Do debounceTime(150ms), '
            'các lần bấm dồn trong khoảng đó sẽ gộp lại trước khi tính toán.',
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}


/**
 Điểm rút ra nhanh

Core StreamController: bạn phải tự giữ _count và tự map event → state. 
Không có sẵn “giá trị hiện tại” cho listener mới (nếu muốn phải tự phát lại/giữ biến).

RxDart BehaviorSubject: có sẵn value và phát ngay giá trị hiện tại cho subscriber mới; 
thêm debounceTime/scan/combineLatest giúp giảm boilerplate và diễn đạt logic rõ ràng hơn.
 */

/**
 
 */