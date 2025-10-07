import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Mấu chốt là nó dược kế thừa từ GetController
class Information extends GetxController {
  // Tạo 1 controller kế thừa từ GetXController
  // Cách 1:  khai báo state
  // late String name;
  // late String zalo;
  // late String website;
  // late String description;

  //Cách 2: Khai báo state

  var name = "".obs;
  var zalo = "".obs;
  var website = "".obs;
  var description = "".obs;
  var map = {}.obs;
  var list = [].obs;

  abc({@required name, @required zalo, @required website, @required description}) {
    // Hàm để có thể thay đổi state trong controller
    this.name = name;
    this.zalo = zalo;
    this.website = website;
    this.description = description;
    update(); // Bắt buộc có , để báo rằng state sẽ thay đổi
  }

  onlyUpDateName({@required name}) {
    // Hàm để có thể thay đổi state trong controller
    this.name = name;
    update(); // Bắt buộc có , để báo rằng state sẽ thay đổi
  }
}
