import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Đây là 1 clas kế thừa từ Class Cubit -- class quản lý - thay đổi giá trị của state
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}