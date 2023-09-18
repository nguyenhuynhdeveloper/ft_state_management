import 'package:flutter/material.dart';
import 'package:demo_ft_state_management/demo_Riverpod/HomePage.dart';
import 'package:demo_ft_state_management/demo_Riverpod/SecondHome.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: <String, WidgetBuilder>{
      '/': (context) => HomePage(),
      '/second': (context) => SecondHome(),
    },
      // home: HomePage(),
  ));
}


class MyApp extends StatelessWidget {  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    initialRoute: '/',
    routes: <String, WidgetBuilder>{
      '/': (context) => HomePage(),
      '/second': (context) => SecondHome(),
    },
    );
  }
}




