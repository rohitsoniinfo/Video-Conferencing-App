import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newapp/LoginSignupFiles/LogInScreen.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newapp/Component/SignUpScreenUiComponent.dart';
import '../UserDetails.dart';
import '../constant.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  bool isAccountCreatedSuccessfully = false;
  bool isOtpSentSuccessfully = false;

  int generateOtp()
  {
    var rng = Random();
    var code = rng.nextInt(90000) + 10000;
    return code;
  }

  int? otpToBeMatched;
  int? enteredOtp;

  bool isComingFromSignUp = true;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  UserDetails userDetails = UserDetails();
  String result = "";

  _updateFirstTimeUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstTimeUser', false);
  }




  Future<void> _showAccountCreatedDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) =>
        AlertDialog(
          title: const Text("You have signed up successfully."),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> const LoginInScreen()), (route) => false);
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.lightBlueAccent)),
              child: const Text("Login Now",style: TextStyle(color: Colors.white),),
            ),
          ],
        ),);
  }
  Future<void> _showErrorDialog({required String message}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) =>  AlertDialog(
        title: Text(message),
        content:TextButton(child: const Text("try again"),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }


  Future<void> _postData() async {
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) {
      return const AlertDialog(
        title: Text("Checking your validity."),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
          ],
        ),
      );
    });
    print("Can your account be created ? ");
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
      if(response.statusCode == 201)
      {
        Navigator.of(context).pop();
        // Successful POST request, handle the response here
        print("account created successfully.");
        final responseData = jsonDecode(response.body);
        setState(() {
          isAccountCreatedSuccessfully = true;
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
        await _showAccountCreatedDialog();
      }
      else {
        print("else block already have an account.");
        Navigator.of(context).pop();
        print("after dimissing the checking dialog. else block already have an account.");
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) =>  AlertDialog(
            title: const Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('Already have an account or error'),
              ],
            ),
            content: TextButton(onPressed: ()  {
              Navigator.of(ctx).pop();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginInScreen()), (route) => false);
            }, child: const Text("okay")),
          ),
        );
        // If the server returns an error response, throw an exception
        throw Exception('Failed to post data');
      }
    } catch (e) {
      setState(() {
        result = 'Error: $e';
      });
    }
    print("this function executed successfully. ");
  }


  Future<void> matchingOtpCreatingAccount() async  {
    if(enteredOtp==otpToBeMatched)
    {
      print("Otp matched successfully.");
      await _postData();
    }
    else
    {
      BuildContext? dContext;
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctxi) {
            dContext = ctxi;
            return  AlertDialog(
              title: const Text('Incorrect OTP'),
              content: TextButton(onPressed: (){
                Navigator.of(dContext!).pop();
              }, child: const Text("okay")),
            );
          }
      );
    }
  }

  Future<void> _enterOtpDialog() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text("Enter your 5 digit OTP recieved on your email."),
            content:  OTPTextField(
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
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  await matchingOtpCreatingAccount();
                  //Navigator.of(context).pop();
                },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.lightBlueAccent)),
                child: const Text("Verify OTP",style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
    );
  }

  void _signUpButtonPressed() async {
    print("signup button pressed.");
    if(_formKey.currentState!.validate())
    {
      otpToBeMatched = generateOtp();
      if(await _emailVerificationOtpSend())
      {
        await _enterOtpDialog();
      }
    }
  }
  Future<bool> _emailVerificationOtpSend() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        title: Text('Sending otp...'),
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

    try {
      final response = await http.post(
        Uri.parse(kApiUrlLink + kEmailVerificationOtpSend),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'to': emailController.text,
          'subject':'OTP Verification',
          'message' : 'Thanks for signing in with us. your OTP(one time password) is: $otpToBeMatched'
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          isOtpSentSuccessfully = true;
        });
        Navigator.of(context).pop();
        print("verification mail sent successfully.");
        return true;
      }
      else
      {
        Navigator.of(context).pop();
        await _showErrorDialog(message: 'Could not send OTP or error');
        // If the server returns an error response, throw an exception
        return false;
        throw Exception('Failed to post data');

      }
    } catch (e) {
      Navigator.of(context).pop();
      await _showErrorDialog(message: 'Could not send OTP or error');
      return false;
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


  String? dropdownValue;

  bool isPasswordVisibility = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          //   Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     // Align(
          //     //     alignment: Alignment.topLeft,
          //     //     child: Container(
          //     //       width: 80,
          //     //       height: 80,
          //     //       decoration: const BoxDecoration(
          //     //           color: Colors.blue ,
          //     //           borderRadius: BorderRadius.only(bottomRight: Radius.circular(200)),
          //     //       ),
          //     //     ),
          //     // ),

          //      Text(
          //       textAlign: TextAlign.center,
          //       'Sign Up ',
          //       style: TextStyle(
          //           color: kAppThemeColor,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 50,
          //           fontStyle: FontStyle.italic),
          //     ),
          //     Align(
          //         alignment: Alignment.topRight,
          //         child: Container(
          //           width: 80,
          //           height: 80,
          //           decoration: const BoxDecoration(
          //               color: Colors.red,
          //               borderRadius:  BorderRadius.only(bottomLeft: Radius.circular(200)),
          //           ),
          //         ),
          //     ),
          //   ],
          // ),
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
                            Container(
                              height: 100,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/loginAnimation.gif'
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[A-Za-z ]+$')),],
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) => value!.length < 3 ? "name is too short." : null,
                              controller: fullNameController,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
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
                                prefixIcon: const  Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: _validateEmail,
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                                prefixIcon: const  Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                           const  SizedBox(height: 10),
                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) => value!.length<10 ? "Please enter a valid contact number" : null,
                              inputFormatters: [ FilteringTextInputFormatter.allow(RegExp(r"[+0-9 -]"))],
                              controller: contactController,
                              decoration: InputDecoration(
                                labelText: 'Contact',
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
                                  Icons.phone,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                             const  SizedBox(height: 10),
                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) => value!.length<4 ? "Please enter a valid address" : null,
                              inputFormatters: [ FilteringTextInputFormatter.allow(RegExp(r'^[A-Za-z ]+$'))],
                              controller: addressController,
                              decoration: InputDecoration(
                                labelText: 'Address',
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
                                errorBorder:const  OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                      color:Colors.red,
                                      width: 3,
                                    )
                                ),
                                prefixIcon:const  Icon(
                                  Icons.location_city,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              validator: (value) => value == null ? "Please select your gender" : null,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              icon: const Icon(Icons.keyboard_arrow_down_rounded),
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                enabledBorder: focusBorder(),
                                focusedBorder: focusBorder(),
                                disabledBorder: focusBorder(),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                      color:Colors.red,
                                      width: 3,
                                    )
                                ),
                                errorBorder:const  OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                      color:Colors.red,
                                      width: 3,
                                    ),
                                ),
                                prefixIcon: const Icon(
                                  Icons.wc,
                                )
                              ),
                              hint:  const Text('Select your gender',style: TextStyle(color: Colors.black),),
                              dropdownColor: Colors.grey.shade200,
                              value: dropdownValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: <String>['Male', 'Female', 'Others',]
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        value,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 10),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value)=>value!.length<6 ? "password length must be least 6." : null,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9.!@#\$%&'*+-/=?^_`{|}~]")),
                            ],
                            controller: passwordController,
                            obscureText: !isPasswordVisibility,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              enabledBorder: inputBorder(),
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
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.resolveWith((states) => 10),
                                    backgroundColor: MaterialStateProperty.resolveWith(
                                        (states) => kAppThemeColor),
                                  ),
                                  onPressed: _signUpButtonPressed,
                                  child:  const Text(
                                    'Signup',
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
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
              const SizedBox(height: 50),
              // TopBottomDesign(
              //     false,
              //     const BorderRadius.only(topRight: Radius.circular(200)),
              //     const BorderRadius.only(topLeft: Radius.circular(200)),
              //     ),
            ],
          ),
        ),
      ),
    );
  }
}