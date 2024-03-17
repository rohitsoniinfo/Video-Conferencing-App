import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newapp/LoginSignupFiles/ForgotPasswordScreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newapp/MainApp/RandomCall.dart';
import 'package:newapp/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../UserDetails.dart';
import 'SignUpScreen.dart';

class LoginInScreen extends StatefulWidget {
  const LoginInScreen({super.key});
  @override
  State<LoginInScreen> createState() => _LoginInScreenState();
}


Future<void>  _setUserLoggedIn() async{
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('isLoggedIn',true);
  print("isLoggedIn: ${prefs.getBool('isLoggedIn')}" );
}

class _LoginInScreenState extends State<LoginInScreen> {
  UserDetails userDetails = UserDetails();
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

  Future<void> _postLoginDAta() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const AlertDialog(
        title: Text('Validating user...'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
    // Send the OTP after a brief delay to simulate network call
    await Future.delayed(const Duration(seconds: 2));
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

          userDetails.userId = responseData['userdata']['id'];
          userDetails.name = responseData['userdata']['name'];
          userDetails.email = responseData['userdata']['email'];
          userDetails.contact = responseData['userdata']['contact'];
          userDetails.address = responseData['userdata']['address'];
          userDetails.gender = responseData['userdata']['gender'];
          userDetails.password = responseData['userdata']['password'];
          Navigator.of(context).pop();

        });
      }
      else
      {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) =>  AlertDialog(
            title: Text('Invalid Credentials'),
            content: TextButton(onPressed: (){
              Navigator.of(context).pop();
            },child: Text('Login Again.'),),
          ),
        );
        // If the server returns an error response, throw an exception
        throw Exception('Failed to post data');
      }
    } catch (e) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) =>  AlertDialog(
          title: Text('Invalid Credentials'),
          content: TextButton(onPressed: (){
            Navigator.of(context).pop();
          },child: Text('Login Again.'),),
        ),
      );
      setState(() {
        result = 'Error: $e';
      });
    }
  }

  TextEditingController fullNameController  = TextEditingController();
  TextEditingController passwordController  = TextEditingController();

  OutlineInputBorder inputBorder(){ //return type is OutlineInputBorder
    return const OutlineInputBorder( //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color:Colors.grey,
          width: 3,
        )
    );
  }

  OutlineInputBorder focusBorder(){
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color:Colors.black,
          width: 3,
        )
    );
  }

  bool isPasswordVisibility = false;

  String? _validateEmail(String? email){
    RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if(!isEmailValid)
      {
        return 'Please enter a valid email';
      }
    return null;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    double width = media.size.width;
    double height = media.size.height;
    print("printing the width: $width, height: $height ");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: kAppBar,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // TopBottomDesign(
            //     true,
            //      BorderRadius.only(bottomRight: Radius.circular((200/752)*height)),
            //      BorderRadius.only(bottomLeft: Radius.circular((200/752)*height)),
            //     ),
            //Text('Login Here', style: TextStyle(color: appThemeColor, fontSize: 50/360*width, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
                const SizedBox(
                  height: 150,
                ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 5,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          tileMode: TileMode.mirror,
                          colors: [
                            kAppThemeColor,
                            Colors.white,
                            kAppThemeColor,
                          ]
                      )
                  ),
                  child: Padding(
                    padding:  EdgeInsets.all((16.0/752)*height),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/animatePerson.gif'
                                  //'assets/images/animatePerson.gif'
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: (10/752)*height),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: _validateEmail,
                            controller: fullNameController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: const  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              enabledBorder: focusBorder(),
                              focusedBorder: focusBorder(),
                              disabledBorder: focusBorder(),
                              focusedErrorBorder:   OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20/752*height)),
                                  borderSide: BorderSide(
                                    color:Colors.red,
                                    width: 3,
                                  ),
                              ),
                              errorBorder: const  OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(
                                    color:Colors.red,
                                    width: 3,
                                  ),
                              ),
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 10/752*height),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) => value!.length<6 ? "password should be more than 6 characters" : null,
                            controller: passwordController,
                            obscureText: !isPasswordVisibility,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              enabledBorder: focusBorder(),
                              focusedBorder: focusBorder(),
                              disabledBorder: focusBorder(),
                              focusedErrorBorder: const  OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(
                                    color:Colors.red,
                                    width: 3,
                                  )
                              ),
                              errorBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(
                                    color:Colors.red,
                                    width: 3,
                                  )
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisibility = !isPasswordVisibility;
                                  });
                                },
                                icon: Icon(
                                  isPasswordVisibility ? Icons.visibility : Icons.visibility_off,
                                ),),
                              prefixIcon: const  Icon(
                                Icons.password,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // SizedBox(height: 10/752*height),
                          TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: const  Text('forgot password?')
                          ),
                          // SizedBox(height: 10/752*height),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith((states) => kAppThemeColor),
                              ),
                              onPressed: ()  async {
                                if(_formKey.currentState!.validate())
                                {
                                  print("it's a valid form. ");
                                  print("clicked login button");
                                  await _postLoginDAta();
                                  await _saveUserDataFirstTime();
                                  await _setUserLoggedIn();
                                  await _setJWTToken();
                                  print("jwtToken : $JWTToken");
                                  if(userId!=null) {
                                    await _setUserLoggedIn();
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => RandomCall()), (route) => false);
                                  }
                                }
                              },
                              child:  const Text('Login ',style: TextStyle(color: Colors.white,fontSize: 20),),
                            ),
                          ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               const Text("Don't have an account? "),
                               TextButton(
                                 style: const ButtonStyle(
                                   //backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.grey),
                                 ),
                                 onPressed: ()  async {
                                   Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                       builder: (context) => SignUpScreen(),
                                     ),
                                   );
                                 },
                                 child:   Text('Signup ',style: TextStyle(color: kAppThemeColor,fontSize: 15),),
                               ),
                             ],
                           ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 34/752*height,),
            // TopBottomDesign(
            //     false,
            //     BorderRadius.only(topRight: Radius.circular(200/752*height),),
            //     BorderRadius.only(topLeft: Radius.circular(200/752*height),),
            //     ),
          ],
        ),
      ),
    );
  }
}