import 'package:demo_ft_state_management/demo_Riverpod/riverpod/IncrementNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_ft_state_management/demo_Riverpod/riverpod/counterProvider.dart';

final valueProvider = Provider<int>((ref) {
  return 36;
});

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: 
//       // Container(height: 200 , width : 200, color: Colors.red)
//        Column(
//          children: [
//            Container(
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/second');
//               },
//               child: Text('Second Home'),
//             ),
//       ),
//          ],
//        ),
//     );
//   }
// }





class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer(
          builder: (_,  watch, __) {
            final value = watch(valueProvider);
            return Text(
              'Value: $value',
              // style: Theme.of(context).textTheme.headline4,
            );
          },
        ),
      ),
    );
  }
}



// // RUN OK 
// class HomePage extends ConsumerStatefulWidget {
//   const HomePage({Key? key}): super(key: key);

//   @override
//   HomePageState createState() => HomePageState();
// }

// class HomePageState extends ConsumerState<HomePage> {
//   @override
//   void initState() {
//     super.initState();
//     // "ref" can be used in all life-cycles of a StatefulWidget.
//     ref.read(counterProvider);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // We can also use "ref" to listen to a provider inside the build method
//     final counter = ref.watch(counterProvider);
//     return Text('$counter');
//   }
// }