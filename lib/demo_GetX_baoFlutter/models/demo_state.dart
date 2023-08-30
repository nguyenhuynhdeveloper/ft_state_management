import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DemoState extends GetxController {
 late String stateString = "State lấy từ GetXController";

  updateDemoState({@required stateString}) {
    this.stateString = stateString;
     update();
  }
}
