// 18/1/2023
// Example  Báo Flutter : https://baoflutter.com/getx-flutter-state-management-cach-quan-ly-state/

import 'package:demo_ft_state_management/demo_GetX_baoFlutter/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
 
void main() {
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(    // Khi sử dụng get thì phải sử dụng GetMaterialApp() thay thế cho MaterialApp()
      home: HomePage(),
    );
  }
}