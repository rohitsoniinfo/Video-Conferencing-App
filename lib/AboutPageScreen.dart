import 'package:flutter/material.dart';
import 'package:newapp/Component/SignUpScreenUiComponent.dart';
class AboutPageScreen extends StatelessWidget {
  const AboutPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            title: Text('About Us',style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,),),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(width: 300, height:300,color: Colors.red,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(width: 300, height:300,color: Colors.yellow,),
                      ),
                    ],
                  ),

                ),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: Colors.grey,
                  child: Column(
                    children: [
                      Container(
                        child: Image.asset('assets/images/RohitSoni1.jpg'),
                        decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),),
                      Text("Rohit Soni",style: TextStyle(color: Colors.white,fontSize: 40, fontWeight: FontWeight.bold,  ),),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child:  Text('Hi!, I am Rohit Soni (Frontend Developer). I am passionate about technologies such as App Development, Cyber Security. I love working on real life projects and turning my ideas into reality.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: Colors.grey,
                  child: Column(
                    children: [
                      Container(
                        child: Image.asset('assets/images/RohitSoni1.jpg'),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),),
                      Text("Rohit Soni",style: TextStyle(color: Colors.white,fontSize: 40, fontWeight: FontWeight.bold,  ),),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child:  Text('Hi!, I am Rohit Soni (Frontend Developer). I am passionate about technologies such as App Development, Cyber Security. I love working on real life projects and turning my ideas into reality.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

          ]),
        ),
          
        ));
  }
}

//Column(
//               children: [
//                 Card(
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                   color: Colors.grey,
//                   child: Column(
//                     children: [
//                       Container(
//                         child: Image.asset('assets/images/RohitSoni1.jpg'),
//                         decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                       ),),
//                       Text("Rohit Soni",style: TextStyle(color: Colors.white,fontSize: 40, fontWeight: FontWeight.bold,  ),),
//                       const Padding(
//                         padding: EdgeInsets.all(16.0),
//                         child:  Text('Hi!, I am Rohit Soni (Frontend Developer). I am passionate about technologies such as App Development, Cyber Security. I love working on real life projects and turning my ideas into reality.',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Card(
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                   color: Colors.grey,
//                   child: Column(
//                     children: [
//                       Container(
//                         child: Image.asset('assets/images/RohitSoni1.jpg'),
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                         ),),
//                       Text("Rohit Soni",style: TextStyle(color: Colors.white,fontSize: 40, fontWeight: FontWeight.bold,  ),),
//                       const Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child:  Text('Hi!, I am Rohit Soni (Frontend Developer). I am passionate about technologies such as App Development, Cyber Security. I love working on real life projects and turning my ideas into reality.',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),


//                 // TopBottomDesign(
//                 //   true,
//                 //   const BorderRadius.only(bottomRight: Radius.circular(200)),
//                 //   const BorderRadius.only(bottomLeft: Radius.circular(200)),
//                 // ),
//                 // Row(
//                 //   children: [
//                 //     Container(
//                 //       width: 180,
//                 //       height: 400,
//                 //       child: Card(
//                 //         color: Colors.red,
//                 //         child: Column(
//                 //         children: [
//                 //           Image.asset('assets/images/videocall.png'),
//                 //           Text('rohit soni is great man. ')
//                 //         ],
//                 //         ),
//                 //       ),),
//                 //     Container(
//                 //       width: 180,
//                 //       height: 400,
//                 //       child: Card(
//                 //         color: Colors.lightBlueAccent,
//                 //         child: Column(
//                 //           children: [
//                 //             Image.asset('assets/images/videocall.png'),
//                 //             Text('sumit patel is great man. ')
//                 //           ],
//                 //         ),
//                 //       ),),
//                 //   ],
//                 // ),
//                 // TopBottomDesign(
//                 //   true,
//                 //   const BorderRadius.only(topRight: Radius.circular(200)),
//                 //   const BorderRadius.only(topLeft: Radius.circular(200)),
//                 // ),
//               ],
//             ),