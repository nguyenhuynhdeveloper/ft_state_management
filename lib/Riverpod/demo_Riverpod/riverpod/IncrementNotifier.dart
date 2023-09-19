import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class IncrementNotifier extends ChangeNotifier {
  int _value = 0;
  int get value => _value;

  void increment() {
    _value += 1;
    notifyListeners();
  }
}

final incrementProvider = ChangeNotifierProvider((ref) => IncrementNotifier());