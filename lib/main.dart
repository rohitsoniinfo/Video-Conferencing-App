import 'package:flutter/material.dart';
import 'package:newapp/AboutPageScreen.dart';
import 'package:newapp/ForgotPasswordScreen.dart';
import 'package:newapp/LogInScreen.dart';
import 'package:newapp/SignUpScreen.dart';
import 'RandomCall.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MaterialApp(home: panel()));

class panel extends StatelessWidget {
  panel({super.key});
  @override
  Widget build(BuildContext context) {
    //return createChannelPage();
    return AppInitializer();
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});
  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isFirstTimeUser = true;

  @override
  void initState() {
    // TODO: implement initState
    _checkFirstTimeUser();
    super.initState();
  }

  _checkFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTimeUser = prefs.getBool('isFirstTimeUser') ?? true;
    setState(() {
      _isFirstTimeUser = isFirstTimeUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isFirstTimeUser ? SignUpScreen() : RandomCall();
  }
}
