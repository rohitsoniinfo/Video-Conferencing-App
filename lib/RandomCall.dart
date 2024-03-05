import 'package:flutter/material.dart';
import 'package:newapp/WaitingCallScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
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
                color: Colors.redAccent,
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
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.email),
                  SizedBox(width: 40,),
                  _mail!=null ? Text(_mail!, style: TextStyle(color: Colors.black, fontSize: 20),) : Text('data'),
                ],
              ),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
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
                // Update the state of the app.
                // ...
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
                // ...
              },
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.password),
                  SizedBox(width: 40,),
                  _password != null ? Text(_password!, style: TextStyle(color: Colors.black, fontSize: 20),) : Text(''),
                ],
              ),
              onTap: () {
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Welcome to app!',
              style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              child: DropdownButton<String>(
                dropdownColor: Colors.grey,
                alignment: Alignment.topCenter,
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
            ),
            Image.asset(
              'assets/images/videocall.png',
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
              'click on the call button to initiate the call.',
                style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold, fontSize: 30),
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
    );
  }
}