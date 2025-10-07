//https://viblo.asia/p/getx-make-flutter-easy-part-2-4P856np15Y3

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/route_manager.dart';

import 'package:demo_ft_state_management/demo_GetX_viblo/DetailPage.dart';
import 'package:demo_ft_state_management/demo_GetX_viblo/SearchPage.dart';

class MyApp extends StatelessWidget {  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      enableLog: true,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // initialBinding: DependenciesBinding(),
      initialRoute: '/SearchPage',
      getPages: list,
    );
  }
}


// ignore: constant_identifier_names
List<GetPage<dynamic>> list   =  [ 
        GetPage(
            name: '/SearchPage',
            page: () => SearchPage(),
            // binding: SearchBinding()
            ),
        GetPage(
            name: '/DetailPage', 
            page: () => DetailPage(), 
            // binding: DetailBinding()
            )
      ];


