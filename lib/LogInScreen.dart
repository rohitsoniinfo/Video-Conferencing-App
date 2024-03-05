import 'package:flutter/material.dart';
//import 'RandomCall.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newapp/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newapp/Component/SignUpScreenUiComponent.dart';
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   centerTitle: true,
      //   backgroundColor: Colors.red,
      //   title: Text(
      //     'Log In',
      //     style: TextStyle(
      //       color: Colors.white,
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TopBottomDesign(
                  true,
                  const BorderRadius.only(bottomRight: Radius.circular(200)),
                  BorderRadius.only(bottomLeft: Radius.circular(200))
                  ),
                  const Text('Login Here',style: TextStyle(color: Colors.blue, fontSize: 50, fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
                  Container(height: 270,width: 300,decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/signupmod.png'))),),
                   //Image.asset('assets/images/signupmod.png'),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    //const SizedBox(height: 10,),
                    //Image.asset('assets/images/signupmod.png'),
                    const SizedBox(height: 10),
                       customTextField('Email or Phone', fullNameController, Icons.person),
                    const SizedBox(height: 10),
                    customTextField('Password', passwordController, Icons.password),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.blue),
                        //fixedSize: MaterialStateProperty.resolveWith((states) => Size(100, 30))
                      ),
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
                      child:  const Text('LogIn ',style: TextStyle(color: Colors.white,fontSize: 20),),
                    ),
                  ],
                ),
              ),
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