import 'package:demo_ft_state_management/demo_GetX_baoFlutter/models/demo_state.dart';
import 'package:demo_ft_state_management/demo_GetX_baoFlutter/models/information.dart';
import 'package:demo_ft_state_management/demo_GetX_baoFlutter/resources/strings.dart';
import 'package:demo_ft_state_management/demo_GetX_baoFlutter/resources/widgets/common_widgets.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'information_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController nameController, zaloController,websiteController,  descriptionController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
    websiteController = TextEditingController();
    zaloController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(INFORMATION_INPUT),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              // name input
              inputWidget(label: NAME, hintText: NAME_INPUT, controller: nameController),
              // Zalo input
              inputWidget(label: ZALO, hintText: ZALO_INPUT, controller: zaloController),
              // Website input
              inputWidget(label: WEBSITE, hintText: WEBSITE_INPUT, controller: websiteController),
              // description input
              inputWidget(label: DESCRIPTION, hintText: DESCRIPTION_INPUT, controller: descriptionController),
              // confirm button
              buttonWidget(
                  lable: CONFIRM,
                  colorButton: Colors.blue,
                  colorText: Colors.yellow,
                  onPress: () {
                    // update information to Provider  : Cập nhật các state tới Provider của GetX

                    // Cách khai báo state dạng biến thường 
                    // Get.put(Information()).abc(
                    //     name: nameController.text, zalo: zaloController.text, website: websiteController.text, description: descriptionController.text);

                    // Để thay đổi giá trị 
                    // Cách khai báo state dạng  .obs
                    // Get.put(Information()).abc(
                    //     name: nameController.text.obs, zalo: zaloController.text.obs, website: websiteController.text.obs, description: descriptionController.text.obs);
                   // Giá trị trong controlner sẽ thay đổi 

                       Get.put(Information()).onlyUpDateName(
                        name: nameController.text.obs);

                    // Để chuyển sang màn thông tin chi tiết 
                    // Routing to Information Page
                    Get.to(InformationPage());

                    Get.put(DemoState());   // Cần bắt buộc put 1 lần để có thể lấy ra giá trị state
                  })
            ],
          ),
        ),
      ),
    );
  }
}
