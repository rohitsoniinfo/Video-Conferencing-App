import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newapp/WaitingCallScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newapp/Component/SignUpScreenUiComponent.dart';
import 'package:http/http.dart' as http;


class RandomCall extends StatefulWidget {
  // const RandomCall({super.key});
  final int? userId;
  final String? name;
  final String? email;
  final String? contact;
  final String? address;
  final String? gender;
  final String? password;
  const RandomCall({Key? key, this.userId, this.name, this.email, this.contact, this.address, this.gender, this.password}) : super(key: key);

  @override
  State<RandomCall> createState() => _RandomCallState();
}

class _RandomCallState extends State<RandomCall> {
  int? _userId;
  String? _name = "";
  String? _mail = "";
  String? _contact;
  String? _address;
  String? _gender;
  String? _password;

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  String dropdownValue = 'male';

  _firstTimeGetSignupData()
  {
    setState(() {
      _name = widget.name;
      _mail = widget.email;
      _userId = widget.userId;
      _contact = widget.contact;
      _address = widget.address;
      _gender = widget.gender;
      _password = widget.password;
    });
  }
  printUserSavedData() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("printing the saved users data : ");
    print(prefs.getString('name'));
    print(prefs.getString('email'));
    print(prefs.getInt('userId'));
    print(prefs.getString('JWTToken'));
    setState(() {
      _userId = prefs.getInt('userId');
      _name = prefs.getString('name');
      _mail = prefs.getString('email');
      _contact = prefs.getString('contact');
      _address = prefs.getString('address');
      _gender = prefs.getString('gender');
      _password = prefs.getString('password');
    });
  }
  @override
  void initState()  {
    _firstTimeGetSignupData();
    printUserSavedData();
    super.initState();
  }


  Future<void> upDateSpecificData(String data) async {
    final response = await http.put(
      Uri.parse('https://dummyjson.com/products/${_userId.toString()}'), //${_userId.toString()}
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': data,
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print("operation successful.");
      final responseData = jsonDecode(response.body);
      print("printing the response email:  ${responseData['title']}");
    }
    else
    {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update album.');
    }
  }

  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        leading: IconButton(
          color: Colors.white,
          onPressed: (){
            if(scaffoldKey.currentState!.isDrawerOpen){
              scaffoldKey.currentState!.closeDrawer();
              //close drawer, if drawer is open
            }else{
              scaffoldKey.currentState!.openDrawer();
              //open drawer, if drawer is closed
            }
          },
          icon:  Icon(Icons.menu,color: Colors.white,),

        ),
        actions: <Widget>[
          IconButton(
            icon:  Icon(Icons.person,color: Colors.white,),
            tooltip: 'Information',
            onPressed: () {
              // handle the press
              printUserSavedData();
            },
          ),
        ],
        title: Text(
          'Random Call App',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.person,color: Colors.white,size: 60,),
                  _name != null ? Text(_name!, style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 30),) : Text(''),
                ],
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.verified_user),
                  SizedBox(width: 40,),
                  _userId != null ? Text(_userId.toString(), style: TextStyle(color: Colors.black, fontSize: 20),) : CircularProgressIndicator(),
                ],
              ),
              onTap: () {
              },
            ),
            ListTile(
              title: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.email),
                    SizedBox(width: 40,),
                    Flexible(
                      child: _mail!=null ? Text(_mail!, style: TextStyle(color: Colors.black, overflow: TextOverflow.ellipsis,fontSize: 20),) : Text('data'),
                    ),
                  ],
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => customAlertDialog(
                      controller: emailController,
                      ctx: ctx,
                      icon: Icons.email,
                      shownText: 'Enter your email',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp( r"[a-zA-Z0-9.@]+")), // Allow only alphabets and space
                    ],
                    method: ()   {
                        print("emailController.text: ${emailController.text}");
                        //Future.delayed(Duration(seconds: 4));
                        upDateSpecificData(emailController.text);
                    },
                  ),
                );
              },
            ),

            //AlertDialog(
            //                     title: const Text("Click save to save data."),
            //                     content: customTextField( 'enter your email',  emailController, Icons.email,
            //                         [
            //                           FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
            //                         ]
            //                     ),
            //                     actions: <Widget>[
            //                       TextButton(
            //                         onPressed: () {
            //                           Navigator.of(ctx).pop();
            //                         },
            //                         child: Text("click save.",style: TextStyle(color: Colors.white),),
            //                         style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.lightBlueAccent)),
            //                       ),
            //                     ],
            //                   ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.place),
                  SizedBox(width: 40,),
                  _address!=null ? Text(_address!, style: TextStyle(color: Colors.black, fontSize: 20),) : Text(''),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => customAlertDialog(
                    controller: addressController,
                    ctx: ctx,
                    icon: Icons.location_on,
                    shownText: 'Enter your address',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                    ],
                    method: () {  },),
                );
              },
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.phone),
                  SizedBox(width: 40,),
                  _contact!=null ? Text(_contact!, style: TextStyle(color: Colors.black, fontSize: 20),) : Text(''),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => customAlertDialog(
                    controller: phoneController,
                    ctx: ctx,
                    icon: Icons.phone,
                    shownText: 'Enter your contact no',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp( r"[a-zA-Z0-9.@]+")), // Allow only alphabets and space
                    ],
                    method: () {  },),
                );

              },
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.person_pin_sharp),
                  SizedBox(width: 40,),
                  _gender!=null ? Text(_gender!, style: TextStyle(color: Colors.black, fontSize: 20),) : Text(''),
                ],
              ),
              onTap: () {
                // Update the state of the app.
                showDialog(
                  context: context,
                  builder: (ctx) => customAlertDialog(
                    controller: genderController,
                    ctx: ctx,
                    icon: Icons.male,
                    shownText: 'Enter your gender',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                    ],
                    method: () {  },),
                );
                // ...
              },
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.password),
                  SizedBox(width: 40,),
                  Flexible(child:
                  _password != null ? Text(_password!, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black, fontSize: 20),) : Text('')
                  ),
                  // _password != null ? Text(_password!, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black, fontSize: 20),) : Text('')
                ],
              ),
              onTap: () {
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Welcome to app!',
                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 30),
              ),
              GestureDetector(
                onTap: (){},
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.lightBlueAccent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                        dropdownColor: Colors.lightBlueAccent,
                        alignment: Alignment.bottomCenter,
                        value: dropdownValue,
                        borderRadius: BorderRadius.circular(20),
                        items: <String>['male', 'female', 'Any'].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  value,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        // Step 5.
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Image.asset(
                'assets/images/videocall.png',
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                'click on the call button to initiate the call.',
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    hoverColor: Colors.red,
                    iconSize: 50,
                    onPressed: () {
                      // getData();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WaitingCallScreen(),
                        ),
                      );
                    },
                    icon: Icon(Icons.phone,color: Colors.white,),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class customAlertDialog extends StatelessWidget {
  const customAlertDialog({
    required this.ctx,
    super.key,
    required this.controller,
    required this.icon,
    required this.shownText,
    required this.inputFormatters,
    required this.method
  });
  final BuildContext ctx;
  final IconData icon;
  final String shownText;
  final List<TextInputFormatter> inputFormatters;
  final TextEditingController controller;
  final void Function() method;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Click save to save data."),
      content: customTextField( shownText,  controller, icon, inputFormatters,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
             method();
            Navigator.of(ctx).pop();
          },
          child: Text("click save.",style: TextStyle(color: Colors.white),),
          style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.lightBlueAccent)),
        ),
      ],
    );
  }
}