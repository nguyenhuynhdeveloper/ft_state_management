import 'package:flutter/material.dart';
// import 'package:demo_ft_state_management/demo_GetX_viblo/demo_GetX.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo_ft_state_management/demo_Riverpod/index.dart';

// import 'package:demo_ft_state_management/demo_variable_global/main.dart';

void main() {
  // runApp(MyApp());
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

