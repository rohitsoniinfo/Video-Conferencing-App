import 'package:flutter/material.dart';
import 'package:newapp/LogInScreen.dart';
import 'package:newapp/PageLogic/UserDetails.dart';
import 'RandomCall.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constant.dart';
import 'package:newapp/Component/SignUpScreenUiComponent.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  

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
        Uri.parse(kApiUrlLink + kSignupApi),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': fullNameController.text,
          'email': emailController.text,
          'contact': contactController.text,
          'address': addressController.text,
          'gender': dropdownValue,
          'password': passwordController.text,
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

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _signUpButtonPressed() async {
    await _postData();
    _updateFirstTimeUserStatus();
    _saveUserDataFirstTime();
    if (userId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginInScreen(),
        ),
      );
    }
  }

  String dropdownValue = 'male';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Container(child: Image.asset('assets/images/signupmod.png',)),
              TopBottomDesign(
                  true,
                  const BorderRadius.only(bottomRight: Radius.circular(200)),
                  BorderRadius.only(bottomLeft: Radius.circular(200))),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      textAlign: TextAlign.center,
                      'Create your Account',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                          fontStyle: FontStyle.italic),
                    ),
                    customTextField(
                        'Full Name', fullNameController, Icons.person),
                    SizedBox(height: 10),
                    customTextField('Email', emailController, Icons.email),
                    SizedBox(height: 10),
                     customTextField('Contact', contactController ,Icons.phone),
                    //   SizedBox(height: 10),
                    // TextField(
                    //   controller: addressController,
                    //   decoration: InputDecoration(labelText: 'Address', enabledBorder: inputBorder(), focusedBorder: focusBorder(),prefixIcon: Icon(Icons.my_location_outlined) ),
                    // ),
                    //SizedBox(height: 10),
                    // Container(
                    //   width: double.infinity,
                    //   decoration: BoxDecoration(
                    //     //color: Colors.red,
                    //     border: Border.all(color: Colors.grey, width: 3),
                    //     borderRadius: BorderRadius.circular(20),
                    //   ),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       const Text(
                    //         'Select you gender',
                    //         style:
                    //             TextStyle(color: Colors.grey, fontSize: 18),
                    //       ),
                    //       Container(
                    //         decoration: BoxDecoration(
                    //             border:
                    //                 Border.all(color: Colors.grey, width: 3),
                    //             borderRadius: BorderRadius.circular(10)),
                    //         child: DropdownButton<String>(
                    //           //dropdownColor: Colors.grey,
                    //           alignment: Alignment.topCenter,
                    //           value: dropdownValue,
                    //           borderRadius: BorderRadius.circular(20),
                    //           items: <String>[
                    //             'male',
                    //             'female',
                    //             'Any'
                    //           ].map<DropdownMenuItem<String>>((String value) {
                    //             return DropdownMenuItem<String>(
                    //               value: value,
                    //               child: Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceEvenly,
                    //                 children: [
                    //                   Text(
                    //                     value,
                    //                     style: const TextStyle(
                    //                         fontSize: 20, color: Colors.grey),
                    //                   ),
                    //                 ],
                    //               ),
                    //             );
                    //           }).toList(),
                    //           // Step 5.
                    //           onChanged: (String? newValue) {
                    //             setState(() {
                    //               dropdownValue = newValue!;
                    //             });
                    //           },
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                    customTextField(
                        'Password', passwordController, Icons.password),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.blue),
                        //fixedSize: MaterialStateProperty.resolveWith((states) => Size(100, 30))
                      ),
                      onPressed: _signUpButtonPressed,
                      child: const Text(
                        'Signup',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              TopBottomDesign(
                  false,
                  const BorderRadius.only(topRight: Radius.circular(200)),
                  const BorderRadius.only(topLeft: Radius.circular(200)),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
