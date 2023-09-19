import 'package:demo_ft_state_management/demo_GetX_viblo/SearchPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/route_manager.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(children: [
          ElevatedButton(
              onPressed: () {
                // Navigation without named routes
                // Get.to(SearchPage());

                // Navigation with named routes
                Get.toNamed('/SearchPage');
              },
              child: Text("Go to Search Page"))
        ]),
      ),
    );
  }
}
