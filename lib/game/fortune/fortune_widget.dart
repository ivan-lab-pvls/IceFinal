// import 'package:flutter/material.dart';
// import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
// import 'dart:async';



// class FortuneWheelWidget extends StatefulWidget {
//   @override
//   _FortuneWheelWidgetState createState() => _FortuneWheelWidgetState();
// }

// class _FortuneWheelWidgetState extends State<FortuneWheelWidget> {
//   final StreamController<int> selectedController = StreamController<int>.broadcast();

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         selectedController.add(Fortune.randomInt(0, items.length));
//       },
//       child: Column(
//         children: [
//           Expanded(
//             child: FortuneWheel(
//               selected: selectedController.stream,
//               items: [
//                 for (var it in items) FortuneItem(
                  
//                   child: Text(it)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
String noBonusesPage = '';
//   @override
//   void dispose() {
//     selectedController.close();
//     super.dispose();
//   }
// }