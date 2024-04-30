import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:newapp/LoginSignupFiles/LogInScreen.dart';
import 'package:newapp/MainApp/BottomNavigation/MorePage.dart';
import 'package:newapp/MainApp/BottomNavigation/UpdatePage.dart';
import 'package:newapp/MainApp/WaitingCallScreen.dart';
import 'package:newapp/constant.dart';
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
  const RandomCall(
      {Key? key,
      this.userId,
      this.name,
      this.email,
      this.contact,
      this.address,
      this.gender,
      this.password})
      : super(key: key);

  @override
  State<RandomCall> createState() => _RandomCallState();
}

class _RandomCallState extends State<RandomCall> {
  bool isMaleClicked = false;
  bool isFemaleClicked = false;

  Future<void> _setUserLoggedOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
  }

  int? _userId;
  String? _name = "";
  String? _mail = "";
  String? _contact;
  String? _address;
  String? _gender;
  String? _password;

  String? JWTToken;

  Future<void> updateJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    JWTToken = prefs.getString('JWTToken');
    print("jwtToken inside the WaitingCallScreen : $JWTToken");
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String dropdownValue = '';

  _firstTimeGetSignupData() {
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

  printUserSavedData() async {
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
  void initState() {
    updateJwtToken();
    _firstTimeGetSignupData();
    printUserSavedData();
    super.initState();
  }

  Future<void> upDateSpecificData(String param, String data) async {
    print("${kApiUrlLink}/api/User/Update/${_userId.toString()}");
    final response = await http.put(
      Uri.parse(
          "${kApiUrlLink}/api/User/Update/${_userId.toString()}"), //${_userId.toString()}
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $JWTToken',
      },
      body: jsonEncode(<String, String>{
        param: data,
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      print("operation successful.");
      final responseData = jsonDecode(response.body);
      print("printing the response $param:  ${responseData[param]}");
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update album.');
    }
  }

  int _currentIndex = 1;

  int i = 0;

  Widget HomePage = SizedBox();

  final List<Widget> screens = [
    const UpdatePage(),
    const SizedBox(),
    const MorePage(),
  ];

  final scaffoldKey = GlobalKey<ScaffoldState>();
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    // double height = size.height;
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        if (_currentIndex != 1) {
          setState(() {
            _currentIndex = 1;
          });
        } else {
          showDialog(
            context: context,
            builder: (contex) => AlertDialog(
              title: Text("Do you want to close this app? "),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("No"),
                ),
                TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: Text("Yes"),
                )
              ],
            ),
          );
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              printUserSavedData();
            });
          },
          currentIndex: _currentIndex,
          mouseCursor: MouseCursor.defer,
          backgroundColor: kAppThemeColor,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.yellow,
          selectedIconTheme: const IconThemeData(color: Colors.yellow),
          unselectedIconTheme: const IconThemeData(color: Colors.grey),
          selectedLabelStyle: const TextStyle(color: Colors.yellow),
          unselectedLabelStyle: const TextStyle(color: Colors.grey),
          items: const [
            BottomNavigationBarItem(
                label: "Update",
                icon: Icon(
                  Icons.update,
                )),
            //BottomNavigationBarItem(label: "Learn",icon:Icon(Icons.book_outlined,)),
            BottomNavigationBarItem(
                label: "Home",
                icon: Icon(
                  Icons.home,
                )),
            //BottomNavigationBarItem(label: "Tips",icon: Icon(Icons.tips_and_updates_outlined,)),
            BottomNavigationBarItem(
                label: "More",
                icon: Icon(
                  Icons.more,
                )),
          ],
        ),
        appBar: _currentIndex == 1
            ? AppBar(
                backgroundColor: kAppThemeColor,
                leading: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    if (scaffoldKey.currentState!.isDrawerOpen) {
                      scaffoldKey.currentState!.closeDrawer();
                      //close drawer, if drawer is open
                    } else {
                      scaffoldKey.currentState!.openDrawer();
                      //open drawer, if drawer is closed
                    }
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    tooltip: 'Information',
                    onPressed: () {
                      // handle the press
                      printUserSavedData();
                    },
                  ),
                ],
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Container(
                    //   height: 50,
                    //   width: (100/393)*width,
                    //   decoration: const BoxDecoration(
                    //       image: DecorationImage(
                    //           image: AssetImage('assets/images/byteBondLogo.png'))),
                    // ),
                    Padding(
                      padding: EdgeInsets.only(left: (15 / 393) * width),
                      child: Text(
                        "byteBond",
                        style: TextStyle(
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold,
                            fontSize: (30 / 393) * width),
                      ),
                    )
                  ],
                ),
              )
            : kAppBar,
        drawer: _currentIndex == 1
            ? Drawer(
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: kAppThemeColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 60,
                          ),
                          _name != null
                              ? Flexible(
                                  child: Text(
                                    _name!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                              : Text(''),
                        ],
                      ),
                    ),
                    // ListTile(
                    //   title: Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: [
                    //       Icon(Icons.verified_user),
                    //       SizedBox(width: 40,),
                    //       _userId != null ? Text(_userId.toString(), style: TextStyle(color: Colors.black, fontSize: 20),) : CircularProgressIndicator(),
                    //     ],
                    //   ),
                    //   onTap: () {
                    //   },
                    // ),
                    ListTile(
                      title: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.email),
                            const SizedBox(
                              width: 40,
                            ),
                            Flexible(
                              child: _mail != null
                                  ? Text(
                                      _mail!,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 20),
                                    )
                                  : Text('data'),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        // showDialog(
                        //   context: context,
                        //   builder: (ctx) => customAlertDialog(
                        //     controller: emailController,
                        //     ctx: ctx,
                        //     icon: Icons.email,
                        //     shownText:
                        //         'after updating your email, you will be redirected to Login page.',
                        //     inputFormatters: [
                        //       FilteringTextInputFormatter.allow(RegExp(
                        //           r"[a-zA-Z0-9.@]+")), // Allow only alphabets and space
                        //     ],
                        //     method: () {
                        //       print("emailController.text: ${emailController.text}");
                        //       //upDateSpecificData("email",emailController.text);
                        //       testingUpdateApi('title', emailController.text);
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => LoginInScreen()));
                        //     },
                        //   ),
                        // );
                      },
                    ),
                    ListTile(
                      title: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.phone),
                            const SizedBox(
                              width: 40,
                            ),
                            _contact != null
                                ? Flexible(
                                    child: Text(
                                      _contact!,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 20),
                                    ),
                                  )
                                : Text(''),
                          ],
                        ),
                      ),
                      onTap: () {
                        // showDialog(
                        //   context: context,
                        //   builder: (ctx) => customAlertDialog(
                        //     controller: phoneController,
                        //     ctx: ctx,
                        //     icon: Icons.phone,
                        //     shownText: 'Enter your contact no',
                        //     inputFormatters: [
                        //       FilteringTextInputFormatter.allow(RegExp(
                        //           r"[a-zA-Z0-9.@]+")), // Allow only alphabets and space
                        //     ],
                        //     method: () {
                        //       upDateSpecificData("contact", phoneController.text);
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => LoginInScreen()));
                        //       Navigator.pushNamedAndRemoveUntil(
                        //           context, '/login', (route) => false);
                        //     },
                        //   ),
                        // );
                      },
                    ),
                    ListTile(
                      title: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.place),
                            const SizedBox(
                              width: 40,
                            ),
                            _address != null
                                ? Flexible(
                                    child: Text(
                                      _address!,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 20),
                                    ),
                                  )
                                : const Text(''),
                          ],
                        ),
                      ),
                      onTap: () {
                        // showDialog(
                        //   context: context,
                        //   builder: (ctx) => customAlertDialog(
                        //     controller: addressController,
                        //     ctx: ctx,
                        //     icon: Icons.location_on,
                        //     shownText: 'Enter your address',
                        //     inputFormatters: [
                        //       FilteringTextInputFormatter.allow(RegExp(
                        //           r"[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                        //     ],
                        //     method: () {
                        //       upDateSpecificData("address", addressController.text);
                        //     },
                        //   ),
                        // );
                      },
                    ),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.person_pin_sharp),
                          const SizedBox(
                            width: 40,
                          ),
                          _gender != null
                              ? Text(
                                  _gender!,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                )
                              : Text(''),
                        ],
                      ),
                      onTap: () {
                        // Update the state of the app.
                        // showDialog(
                        //   context: context,
                        //   builder: (ctx) => customAlertDialog(
                        //     controller: genderController,
                        //     ctx: ctx,
                        //     icon: Icons.male,
                        //     shownText: 'Enter your gender',
                        //     inputFormatters: [
                        //       FilteringTextInputFormatter.allow(RegExp(
                        //           r"[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                        //     ],
                        //     method: () {
                        //       upDateSpecificData("gender", genderController.text);
                        //     },
                        //   ),
                        // );
                        // ...
                      },
                    ),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.password),
                          const SizedBox(
                            width: 40,
                          ),
                          Flexible(
                              child: _password != null
                                  ? Text(
                                      _password!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    )
                                  : Text('')),
                          // _password != null ? Text(_password!, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black, fontSize: 20),) : Text('')
                        ],
                      ),
                      onTap: () {
                        // showDialog(
                        //   context: context,
                        //   builder: (ctx) => customAlertDialog(
                        //     controller: passwordController,
                        //     ctx: ctx,
                        //     icon: Icons.password,
                        //     shownText: 'Enter your password',
                        //     inputFormatters: [
                        //       FilteringTextInputFormatter.allow(RegExp(
                        //           r"[a-zA-Z0-9.@]+")), // Allow only alphabets and space
                        //     ],
                        //     method: () {
                        //       upDateSpecificData("password", passwordController.text);
                        //     },
                        //   ),
                        // );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: OutlinedButton(
                        onPressed: () async {
                          await _setUserLoggedOut();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginInScreen()),
                              (route) => false);
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.red)),
                        child: const Text(
                          "Logout",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : null,
        body: _currentIndex == 1
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      elevation: 10,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "Who are you interested in connecting with?",
                              style: TextStyle(
                                  color: kAppThemeColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    'Male',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        i = 1;
                                        dropdownValue = "Male";
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: MaterialStateColor.resolveWith(
                                            (states) => i == 1
                                                ? const Color(0xff5c5e92)
                                                : const Color(0xffebe4f2),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        width: 150,
                                        height: 150,
                                        child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/male.gif'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text(
                                    'Female',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        i = 2;
                                        dropdownValue = "Female";
                                      });
                                    },
                                    onDoubleTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                MaterialStateColor.resolveWith(
                                              (states) => i == 2
                                                  ? const Color(0xff5c5e92)
                                                  : const Color(0xffebe4f2),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        width: 150,
                                        height: 150,
                                        child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/female.gif'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(10),
                              //backgroundColor: MaterialStateProperty.all(Colors.redAccent)
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WaitingCallScreen(
                                    gender: dropdownValue,
                                  ),
                                ),
                              );
                            },
                            icon: Container(
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/call.gif"))),
                            ),
                          ),
                        ],
                      ),
                    ),
                   const Padding(
                      padding:  EdgeInsets.all(8.0),
                      child:  Card(
                          elevation: 10,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 100,
                                child: Center(
                                  child: Text(
                                    "Total Active Users right now: 1000+",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              )
            : screens[_currentIndex],
      ),
    );
  }
}

//Container(
//                       height: 50,
//                       width: 50,
//                       decoration: const BoxDecoration(
//                         image: DecorationImage(
//                           image: AssetImage("assets/images/callingButton.gif")
//                         )
//                       ),
//                     )

//Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => WaitingCallScreen(
//                             gender: dropdownValue,
//                           ),
//                         ),
//                       );

class customAlertDialog extends StatelessWidget {
  const customAlertDialog(
      {required this.ctx,
      super.key,
      required this.controller,
      required this.icon,
      required this.shownText,
      required this.inputFormatters,
      required this.method});
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
      content: customTextField(
        shownText,
        controller,
        icon,
        inputFormatters,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            method();
            Navigator.of(ctx).pop();
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.lightBlueAccent)),
          child: const Text(
            "click save.",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
