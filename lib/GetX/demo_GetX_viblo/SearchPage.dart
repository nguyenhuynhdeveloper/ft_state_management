import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/route_manager.dart';

import 'package:demo_ft_state_management/demo_GetX_viblo/DetailPage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: Column(
        children: [

          // Navigate  màn hình 
          ElevatedButton(
              onPressed: () {
                // Navigation without named routes
                Get.to(DetailPage());

                // Navigation with named routes
                // Get.toNamed('/DetailPage');
              },
              child: Container(
                height: 100,
                width: 100,
                color: Colors.red,
                child: Text("Go to Detail"))),

          // Show snack bar không cũtom 
          ElevatedButton(
              onPressed: () {
                Get.snackbar('Hi', 'i am a modern snackbar');
              },
              child: Text("Show Snackbar")),

          //show snack bar có custom 
            ElevatedButton(
              onPressed: () {
                Get.snackbar(
              "Hey i'm a Get SnackBar!", // title
              "It's unbelievable! I'm using SnackBar without context!", // message
              icon: Icon(Icons.alarm),
              shouldIconPulse: true,

              snackPosition: SnackPosition.BOTTOM,
       
              // onTap:() { print('vùa bam  vao');},
              isDismissible: true,
              duration: Duration(seconds: 3),
            );
              },
              child: Text("Show Snackbar have custom")),

          // Show dialog : hình mặc định 
          ElevatedButton(
              onPressed: () {
                // Định dialog ở đây luôn : Xấu , custom đk  nhiều 
                // To open default dialog:
                Get.defaultDialog(onConfirm: () => {
                  Get.back(),     // Đóng Dialog
                  print("Ok")}, 
                middleText: "Dialog made in 3 lines of code");
              },
              child: Text("Show Dialog")),

          // Show dialog : Có Custom 
          ElevatedButton(
              onPressed: () {

                // Vẽ sẵn 1 cái widget thôi 
                //To open dialog:
                Get.dialog(ExampleAlertDialog());

              
              },
              child: Text("Show Dialog have custom")),


            ElevatedButton(
              onPressed: () {
              //Get.bottomSheet is like ModalBottomSheet, but don't need of context.

                  Get.bottomSheet(
                    Container(
                      child: Wrap(
                        children: <Widget>[
                          Container(
                            height: 800,
                            color: Colors.amber,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.music_note),
                                  title: Text('Music'),
                                  onTap: () => {}
                                ),
                                TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter a search term',
                                ),
                              ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  );
              },
              child: Text("Show BottomSheets"))
        ],
      )),
    );
  }
}


// Widget ExampleAlertDialog(context) {
//   return AlertDialog(
//     title: const Text('AlertDialog Title'),
//     content: const Text('AlertDialog description'),
//     actions: <Widget>[
//       TextButton(
//         onPressed: () => Navigator.pop(context, 'Cancel'),
//         child: const Text('Cancel'),
//       ),
//       TextButton(
//         onPressed: () => Navigator.pop(context, 'OK'),
//         child: const Text('OK'),
//       ),
//         TextButton(
//         onPressed: () => Navigator.pop(context, 'OK'),
//         child: const Text('OK'),
//       ),
//     ],
//   );
// }

Widget ExampleAlertDialog() {
  return AlertDialog(
    title: const Text('AlertDialog Title'),
    content: Container(
       height: 100,
       color: Colors.amber,
      
      child:  FadeInImage.assetNetwork(
                placeholder: 'assets/images/girl.jpeg',
                image: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
              ),),
    actions: <Widget>[
      TextButton(
        onPressed: () => Get.back(),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () => Get.back(),
        child: const Text('OK'),
      ),
        TextButton(
        onPressed: () =>  Get.back(),
        child: const Text('OK'),
      ),
    ],
  );
}