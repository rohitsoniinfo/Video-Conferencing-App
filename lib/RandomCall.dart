import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:newapp/UserData.dart';
import 'package:newapp/WaitingCallScreen.dart';
import 'constants.dart';
class RandomCall extends StatefulWidget {
  // const RandomCall({super.key});
  final int? userId;
  final String? name;
  final String? email;
  const RandomCall({Key? key,  this.userId,  this.name,  this.email}) : super(key: key);

  @override
  State<RandomCall> createState() => _RandomCallState();
}

class _RandomCallState extends State<RandomCall> {

  String _name = uniqueUserName;
  String _mail = uniqueEmailID;

  @override
  void initState() {
    // print("printing data from RandomCall() class. ");
    // print("userId: ${widget.userId}");
    // print("name: ${widget.name}");
    // print("email: ${widget.email}");
    if(uniqueUserName.isEmpty ||  uniqueEmailID.isEmpty || uniqueUserID == null)
      {
        uniqueUserName = widget.name!;
        uniqueEmailID = widget.email!;
        uniqueUserID = widget.userId!;
      }
    _name = uniqueUserName;
    _mail = uniqueEmailID;
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
                  Text(_name, style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 30),),
                ],
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.verified_user),
                  SizedBox(width: 40,),
                  widget.userId != null ? Text(widget.userId.toString(), style: TextStyle(color: Colors.black, fontSize: 20),) : CircularProgressIndicator(),
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
                  Text(_mail, style: TextStyle(color: Colors.black, fontSize: 20),),
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
                  Text('Password', style: TextStyle(color: Colors.black, fontSize: 20),),
                ],
              ),
              onTap: () {
                // Update the state of the app.
                // ...
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
