import 'package:flutter/material.dart';

import 'package:newapp/CreateChannelPage.dart';

void main() => runApp( MaterialApp(home: panel()));

class panel extends StatelessWidget {
   panel({super.key});
  @override
  Widget build(BuildContext context) {
    return createChannelPage();
  }
}






//Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Basic App'
//         ),
//         backgroundColor: Colors.red,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextButton(
//                     onPressed: (){
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) =>  AudioFunctionalityApp()),
//                       );
//                     },
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.red),
//                     shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
//                   ),
//                   child: Text(
//                         'audio',
//
//                       style: TextStyle(
//                           fontSize: 50,
//                         color: Colors.white,
//                       ),
//                     ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextButton(
//                     onPressed: (){
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) =>  MyApp()),
//                       );
//
//                     },
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.red),
//                       shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
//                     ),
//                     child: Text(
//                       'video',
//                       style: TextStyle(
//                         fontSize: 50,
//                         color: Colors.white,
//                       ),
//                     )),
//               ),
//             ],
//           ),
//           TextButton(
//             onPressed: (){
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) =>  UiKit()),
//               );
//             },
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.red),
//               shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
//             ),
//             child: Text(
//               'UI KIT',
//               style: TextStyle(
//                 fontSize: 50,
//                 color: Colors.white,
//               ),
//             ),
//           )
//         ],
//       ),
//     )