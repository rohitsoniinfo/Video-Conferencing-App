import 'package:flutter/material.dart';
//import 'RandomCall.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newapp/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'RandomCall.dart';


class LoginInScreen extends StatefulWidget {
  const LoginInScreen({super.key});
  @override
  State<LoginInScreen> createState() => _LoginInScreenState();
}


class _LoginInScreenState extends State<LoginInScreen> {

  String result = "";

  String? name;
  String? password;

  String? JWTToken;
  int? userId;

  _setJWTToken() async
  {
    final refs = await SharedPreferences.getInstance();
    refs.setString('JWTToken', JWTToken!);
    refs.setInt('userId', userId!);
  }


  Future<void> _postLoginDAta() async {
    try
    {
      final response = await http.post(
        Uri.parse(kApiUrlLink+kLoginApi),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'username': fullNameController.text,
          'password':passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Successful POST request, handle the response here
        final responseData = jsonDecode(response.body);
        print(responseData);
        setState(() {
          result = 'Name: ${responseData['username']}\n'
              'Id: ${responseData['id']}\n'
              'Token : ${responseData['jwtToken']} \n ';
          userId = responseData['id'];
          JWTToken = responseData['jwtToken'];
          print("jwtToken bc : $JWTToken");
          print(result);
          print(JWTToken);
        });
      }
      else
      {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to post data');
      }
    } catch (e) {
      setState(() {
        result = 'Error: $e';
      });
    }
  }


  TextEditingController fullNameController  = TextEditingController();
  TextEditingController passwordController  = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        title: Text(
          'Log In',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(child: Image.asset('assets/images/signupmod.png',)),
            Card(
              margin: EdgeInsets.all(20.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset('assets/images/signupmod.png'),
                    TextField(
                      controller: fullNameController,
                      decoration: InputDecoration(labelText: 'Email or Phone'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: ()  async {
                        print("clicked login button");
                        await _postLoginDAta();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RandomCall(),
                            ),
                          );
                        print("jwtToken : $JWTToken");

                        _setJWTToken();
                      },
                      child: Text('LogIn'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}