import 'package:demo_ft_state_management/demo_GetX_baoFlutter/models/demo_state.dart';
import 'package:demo_ft_state_management/demo_GetX_baoFlutter/models/information.dart';
import 'package:demo_ft_state_management/demo_GetX_baoFlutter/resources/strings.dart';
import 'package:demo_ft_state_management/demo_GetX_baoFlutter/resources/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InformationPage extends StatefulWidget {
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(INFORMATION_INPUT),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            // Lấy giá trị của state từ GetXController :
            children: [
              // Cách khai báo state dạng biến thường
              // DemoGetBuilder(),
              // DemoGetFind()

              //Cách khai báo state dạng .obs
              DemoGetPut(),
              // DemoObx()
            ],
          ),
        ));
  }
}

Widget DemoGetBuilder() {
  return // Cách 1 :  dùng GetBuilder để build Widget và hiển thị các giá trị.
      GetBuilder<Information>(
    init: Information(), // khai báo sẽ gọi ở controller chứa state
    builder: (information) {
      return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            informationWidget(label: NAME, content: information.name),
            Divider(),
            informationWidget(label: ZALO, content: information.zalo),
            Divider(),
            informationWidget(label: WEBSITE, content: information.website),
            Divider(),
            informationWidget(label: DESCRIPTION, content: information.description),
            Divider(),
          ],
        ),
      );
    },
  );
}

// Cách 2:   // Sử dụng lấy state bằng Get.find()
Widget DemoGetFind() {
  final Information informationGetFind = Get.find(); // Sử dụng Get.find() : để tìm tới controller chứa state
  final DemoState demoState1 = Get.find();

  return Container(
    padding: EdgeInsets.all(10),
    child: Column(
      children: [
        informationWidget(label: NAME, content: informationGetFind.name),
        Divider(),
        informationWidget(label: ZALO, content: informationGetFind.zalo),
        Divider(),
        informationWidget(label: WEBSITE, content: informationGetFind.website),
        Divider(),
        informationWidget(label: DESCRIPTION, content: informationGetFind.description),
        Divider(),
        Text(demoState1.stateString)
      ],
    ),
  );
}

//------- Khi khai báo state kiểu .obs
Widget DemoGetPut() {
  final Information informationController = Get.put(Information());  // Sẽ lấy ra các giá trị state trong controller của getX
  return Container(
    padding: EdgeInsets.all(10),
    child: Column(
      children: [
        informationWidget(label: NAME, content: informationController.name.value),
        Divider(),
        informationWidget(label: ZALO, content: informationController.zalo.value),
        Divider(),
        informationWidget(label: WEBSITE, content: informationController.website.value),
        Divider(),
        informationWidget(label: DESCRIPTION, content: informationController.description.value),
        Divider(),
      ],
    ),
  );
}

// sử dụng Obx để hiển thị lên view:
Widget DemoObx() {
   final Information information = Get.find();
  return Obx(() => Column(
        children: [
          informationWidget(label: NAME, content: information.name.value),
          Divider(),
          informationWidget(label: ZALO, content: information.zalo.value),
          Divider(),
          informationWidget(label: WEBSITE, content: information.website.value),
          Divider(),
          informationWidget(label: DESCRIPTION, content: information.description.value),
          Divider(),
        ],
      ));
}
