import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newapp/LogInScreen.dart';
import 'RandomCall.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constant.dart';
import 'package:newapp/Component/SignUpScreenUiComponent.dart';
import 'UserDetails.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  UserDetails userDetails = UserDetails();
  String result = "";


  _saveUserDataFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('userId', userDetails.userId!);
    prefs.setString('name', userDetails.name!);
    prefs.setString('email', userDetails.email!);
    prefs.setString('contact', userDetails.contact!);
    prefs.setString('address', userDetails.address!);
    prefs.setString('gender', userDetails.gender!);
    prefs.setString('password', userDetails.password!);
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
          userDetails.userId = responseData['id'];
          userDetails.name = responseData['name'];
          userDetails.email = responseData['email'];
          userDetails.contact = responseData['contact'];
          userDetails.address = responseData['address'];
          userDetails.gender = responseData['gender'];
          userDetails.password = responseData['password'];
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


  void _signUpButtonPressed() async {
    await _postData();
    _updateFirstTimeUserStatus();
    _saveUserDataFirstTime();
    if (userDetails.userId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginInScreen(),
        ),
      );
    }
  }

  String dropdownValue = 'Male';
  int intDropDownValue(String str)
  {
    if(str == "Male")
      {
        return 0;
      }
    else if (str == "Female")
      {
        return 1;
      }
    else
      {
        return 2;
      }
  }

  bool isPasswordVisibility = false;

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
              // TopBottomDesign(
              //     true,
              //     const BorderRadius.only(bottomRight: Radius.circular(200)),
              //     BorderRadius.only(bottomLeft: Radius.circular(200))),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        color: Colors.blue ,
                        borderRadius:   const BorderRadius.only(bottomRight: Radius.circular(200)),
                    ),
                  ),
              ),
              const Text(
                textAlign: TextAlign.center,
                'Sign Up ',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    fontStyle: FontStyle.italic),
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(200)),
                    ),
                  ),
              ),
            ],
          ),
              const SizedBox(
                height: 30,
              ),
              // const Text(
              //   textAlign: TextAlign.center,
              //   'Create your Account',
              //   style: TextStyle(
              //       color: Colors.blue,
              //       fontWeight: FontWeight.bold,
              //       fontSize: 50,
              //       fontStyle: FontStyle.italic),
              // ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    customTextField(
                      'Full Name',
                      fullNameController,
                      Icons.person,
                      [
                        FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9.@]+")), // Allow only alphabets and space
                        LengthLimitingTextInputFormatter(20), // Limit the total length
                      ]
                    ),
                    SizedBox(height: 10),
                    customTextField(
                      'Email', emailController, Icons.email,
                        [
                          FilteringTextInputFormatter.allow(RegExp( r"[a-zA-Z0-9.@]+")), // Allow only alphabets and space
                        ],
                    ),
                    SizedBox(height: 10),
                     customTextField('Contact', contactController ,Icons.phone,
                       [
                         FilteringTextInputFormatter.allow(RegExp(r"[+0-9 -]")),
                       ]
                     ),
                      SizedBox(height: 10),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(labelText: 'Address', enabledBorder: inputBorder(), focusedBorder: focusBorder(),prefixIcon: Icon(Icons.my_location_outlined) ),
                      textInputAction: TextInputAction.none,
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        //color: Colors.red,
                        border: Border.all(color: Colors.black, width: 3),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Icon(Icons.male),  Icon(Icons.female),
                                SizedBox(width: 10,),
                                Text('Gender', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                          DropdownButton<String>(
                            //dropdownColor: Colors.grey,
                            alignment: Alignment.bottomCenter,
                            value: dropdownValue,
                            borderRadius: BorderRadius.circular(20),
                            items: <String>[
                              'Male',
                              'Female',
                              'Others'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      value,
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.indigo),
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
                    const SizedBox(height: 10),
                  TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9.!@#\$%&'*+-/=?^_`{|}~]")),
                    ],
                    controller: passwordController,
                    obscureText: !isPasswordVisibility,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      enabledBorder: inputBorder(),
                      focusedBorder: focusBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordVisibility = !isPasswordVisibility;
                          });
                        },
                        icon: Icon(
                          isPasswordVisibility ? Icons.visibility : Icons.visibility_off,
                      ),),
                      prefixIcon: Icon(
                        Icons.password,
                        color: Colors.black,
                      ),
                    ),
                  ),
                    // customTextField(
                    //     'Password', passwordController, Icons.password,
                    //   [
                    //     FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9.!@#\$%&'*+-/=?^_`{|}~]")),
                    //   ]
                    // ),
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
