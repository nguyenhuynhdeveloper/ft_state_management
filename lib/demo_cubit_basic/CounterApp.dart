import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_page.dart';
import 'counter_cubit.dart';


class CounterApp extends StatelessWidget {
  const CounterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        // Nơi khởi tạo Bloc
        create: (_) => CounterCubit(),
        child: CounterPage(),
      ),
    );
  }
}
