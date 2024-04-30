import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:newapp/Component/SignUpScreenUiComponent.dart';
import 'package:newapp/Component/Validator.dart';
import 'package:newapp/LoginSignupFiles/LogInScreen.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:http/http.dart' as http;
import '../constant.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  Validator validatorObj = Validator();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mailController = TextEditingController();

  bool isPasswordVisibility = false;
  String result = "";
  int? enteredOtp;


  bool isPasswordChangedSuccessfully = false;

  bool isOtpSentSuccessfully = false;
  Future<bool> _emailVerificationOtpSend() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const PopScope(
        canPop: false,
        child:  AlertDialog(
          title: Text('Sending OTP...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
    await Future.delayed(const Duration(seconds: 2));

    print("email id entered: ${mailController.text}");
    try {
      final response = await http.post(
        Uri.parse(kApiUrlLink + kForgotPasswordOtpSend),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'to': mailController.text,
        }),
      );
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        setState(() {
          isOtpSentSuccessfully = true;
        });
        print("OTP sent successfully.");
        return true;
      }
      else {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) =>  AlertDialog(
            title:  Text('Coundn\'t send OTP or error. ResponseCode: ${response.statusCode}'),
            content: TextButton(onPressed: (){
              Navigator.of(context).pop();
            },child: const Text("Okay"),),
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
          title:  Text('error. exception: $e'),
          content: TextButton(onPressed: (){
            Navigator.of(context).pop();
          },child: const Text("Okay"),),
        ),
      );
      setState(() {
        result = 'Error: $e';
      });
      return false;
    }
  }

  Future<void> _verifyOtpChangePassword() async
  {
    print("verifying otp......");
    print("updating password.......");
    try {
      final response = await http.post(
        Uri.parse(kApiUrlLink + kSetPassword),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'otp': enteredOtp.toString(),
          'password':passwordController.text
        }),
      );
      if (response.statusCode == 200) {
        print("password updated successfully.");
        setState(() {
          isPasswordChangedSuccessfully = true;
        });
      }
      else {
        // If the server returns an error response, throw an exception
        //Navigator.of(context).pop();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) =>  AlertDialog(
            title: const Text('Invalid OTP or error'),
            content: TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: const Text("Okay")),
          ),
        );
        throw Exception('Failed to post data');
      }
    } catch (e) {
      //Navigator.of(context).pop();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) =>  AlertDialog(
          title: const Text('Invalid OTP or error'),
          content: TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              }, child: const Text("Okay")),
        ),
      );
      setState(() {
        result = 'Error: $e';
      });
    }
  }

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
  final _otpPasswordFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: kAppBar,
          body: SingleChildScrollView(
          child: Column(
          children: [
            // TopBottomDesign(
            //   true,
            //   const BorderRadius.only(bottomRight: Radius.circular(200)),
            //   const BorderRadius.only(bottomLeft: Radius.circular(200)),
            // ),
            const SizedBox(height: 150,),
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
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("Forgot password",style: TextStyle(color: kAppThemeColor,fontSize: 30,fontWeight: FontWeight.bold),),
                          ),
                          Container(
                            height: 100,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/forgotPerson.gif'
                                ),
                              ),
                            ),
                          ),
                         const SizedBox(height: 10,),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: _validateEmail,
                            controller: mailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              enabledBorder: focusBorder(),
                              focusedBorder: focusBorder(),
                              disabledBorder: focusBorder(),
                              focusedErrorBorder:  const OutlineInputBorder(
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
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith(
                                        (states) => kAppThemeColor),
                              ),
                              onPressed:  () async {
                                if(_formKey.currentState!.validate())
                                {
                                  if(await _emailVerificationOtpSend())
                                    {
                                      await showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (ctx) =>
                                            AlertDialog(
                                              title: const Text("Enter the otp recieved and set password"),
                                              content:  SingleChildScrollView(
                                                child: Form(
                                                  key: _otpPasswordFormKey,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.all(16.0),
                                                        child: Text("Enter your otp ",style: TextStyle(color: Colors.black, fontSize: 20)),
                                                      ),
                                                      OTPTextField(
                                                        otpFieldStyle: OtpFieldStyle(
                                                          enabledBorderColor: Colors.black,
                                                          disabledBorderColor: Colors.blueGrey,
                                                          errorBorderColor: Colors.red,
                                                        ),
                                                        length: 5,
                                                        width: MediaQuery.of(context).size.width,
                                                        //fieldWidth: 40,
                                                        style: const TextStyle(
                                                            fontSize: 17
                                                        ),
                                                        textFieldAlignment: MainAxisAlignment.spaceAround,
                                                        fieldStyle: FieldStyle.box,
                                                        onCompleted: (pin) {
                                                          enteredOtp = int.parse(pin);
                                                          print("Completed: $pin");
                                                        },
                                                      ),
                                                      const Padding(
                                                        padding: EdgeInsets.all(16.0),
                                                        child: Text("Enter your password ",style: TextStyle(color: Colors.black, fontSize: 20)),
                                                      ),
                                                      TextFormField(
                                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                                        validator: validatorObj.passwordValidator,
                                                        inputFormatters: validatorObj.passwordFormatter,
                                                        controller: passwordController,
                                                        obscureText: isPasswordVisibility,
                                                        decoration: InputDecoration(
                                                          labelText: 'Password',
                                                          labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                          enabledBorder: inputBorder(),
                                                          focusedBorder: focusBorder(),
                                                          disabledBorder: focusBorder(),
                                                          focusedErrorBorder:  const OutlineInputBorder(
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
                                                          prefixIcon: const Icon(
                                                            Icons.password ,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () async {
                                                    if(_otpPasswordFormKey.currentState!.validate())
                                                    {
                                                      await _verifyOtpChangePassword();
                                                      Navigator.of(ctx).pop();
                                                    }
                                                  },
                                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.lightBlueAccent)),
                                                  child: const Text("Verify OTP and Set password",style: TextStyle(color: Colors.white),),
                                                ),
                                              ],
                                            ),
                                      );
                                    }
                                  if(isPasswordChangedSuccessfully)
                                  {
                                    showDialog(context: context, builder: (ctx) => AlertDialog(
                                      title: const Text('Your password is updated successfully.'),
                                      actions: [
                                        TextButton(
                                          onPressed: ()  {
                                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginInScreen()), (route) => false);
                                            //Navigator.of(ctx).pop();
                                          },
                                          style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.lightBlueAccent)),
                                          child: const Text("Login Again.",style: TextStyle(color: Colors.white),),
                                        ),
                                      ],
                                    ));
                                  }
                                }
                              },
                              child: const Text(
                                'Send OTP ',
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}