import 'package:flutter/material.dart';
import 'package:newapp/LogInScreen.dart';
import 'RandomCall.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  String apiUrl = 'https://f10a-2409-40c4-3019-c899-1c1d-f59c-a36d-fc4f.ngrok-free.app';
  String signupApiString = '/api/User/Create';
  String result = "";

  int? userId;
  String? name;
  String? email;
  String? contact;
  String? address;
  String? gender;
  String? password;


  _saveUserDataFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('userId', userId!);
    prefs.setString('name', name!);
    prefs.setString('email', email!);
    prefs.setString('contact', contact!);
    prefs.setString('address', address!);
    prefs.setString('gender', gender!);
    prefs.setString('password', password!);
  }

  _updateFirstTimeUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstTimeUser', false);
  }

  Future<void> _postData() async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl+signupApiString),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': fullNameController.text,
          'email': emailController.text,
          'contact': contactController.text,
          'address': addressController.text,
          'gender': dropdownValue,
          'password':passwordController.text,
        }),
      );

      if (response.statusCode == 201) {
        // Successful POST request, handle the response here
        final responseData = jsonDecode(response.body);
        setState(() {
          result = 'ID: ${responseData['id']}\n'
              'Name: ${responseData['name']}\n'
              'Email: ${responseData['email']}\n'
              'Contact: ${responseData['contact']}\n'
              'Address: ${responseData['address']}\n'
              'Gender: ${responseData['gender']}\n'
              'Password: ${responseData['password']}\n';
          userId = responseData['id'];
          name = responseData['name'];
          email = responseData['email'];
          contact = responseData['contact'];
          address = responseData['address'];
          gender = responseData['gender'];
          password = responseData['password'];
          print(result);
        });
      } else {
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
  TextEditingController emailController  = TextEditingController();
  TextEditingController contactController  = TextEditingController();
  TextEditingController addressController  = TextEditingController();
  TextEditingController genderController  = TextEditingController();
  TextEditingController passwordController  = TextEditingController();



  String dropdownValue = 'male';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        title: Text(
          'Sign Up',
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
                    TextField(
                      controller: fullNameController,
                      decoration: InputDecoration(labelText: 'Full Name'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                        controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: contactController,
                      decoration: InputDecoration(labelText: 'Contact'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(labelText: 'Adress'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      readOnly: true,
                      autofocus: false,
                      //controller: genderController,
                      decoration: InputDecoration(
                          labelText: dropdownValue,
                        suffixIcon: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            //color: Colors.red,
                          ),
                          child: DropdownButton<String>(
                            //dropdownColor: Colors.grey,
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
                                      style: TextStyle( fontSize: 20),
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
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await _postData();
                        _updateFirstTimeUserStatus();
                        _saveUserDataFirstTime();
                        if(userId != null)
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginInScreen(),
                              ),
                            );
                          }
                      },
                      child: Text('Signup'),
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