import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newapp/LoginSignupFiles/LogInScreen.dart';
import 'MainApp/RandomCall.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  return runApp(
      const MaterialApp(debugShowCheckedModeBanner: false, home: panel()));
}

class panel extends StatelessWidget {
  const panel({super.key});
  @override
  Widget build(BuildContext context) {
    //return createChannelPage();
    return const AppInitializer();
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});
  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isUserLoggedin = false;
  @override
  void initState() {
    _checkUserLoggedIn();
    super.initState();
  }
  Future<void> _checkUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isUserLoggedin = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      _isUserLoggedin = isUserLoggedin;
    });
    print("isLoggedIn: inside the main  _checkUserLoggedIn() function : ${prefs.getBool('isLoggedIn')}");
  }
  @override
  Widget build(BuildContext context) {
    return _isUserLoggedin ? const RandomCall() : const LoginInScreen();
  }
}