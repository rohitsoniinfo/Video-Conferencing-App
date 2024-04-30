import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newapp/Component/Validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Component/SignUpScreenUiComponent.dart';
import '../../constant.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});
  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  Validator validator = Validator();

  int? _userId;
  String? _name = "";
  String? _mail = "";
  String? _contact;
  String? _address;
  String? _gender;
  String? _password;

  String? JWTToken;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String dropdownValue = 'Female';

  updatingNewValue(String param, String value) async
  {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(param, value);
    setState(() {
      printUserSavedData();
    });
    print("${prefs.getString(param)}");
  }


  printUserSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("printing the saved users data : ");
    print(prefs.getString('name'));
    print(prefs.getString('email'));
    print(prefs.getInt('userId'));
    print(prefs.getString('JWTToken'));
    setState(() {
      _userId = prefs.getInt('userId');
      _name = prefs.getString('name');
      _mail = prefs.getString('email');
      _contact = prefs.getString('contact');
      _address = prefs.getString('address');
      _gender = prefs.getString('gender');
      _password = prefs.getString('password');
      nameController.text = _name!;
      dropdownValue = _gender!;
      addressController.text = _address!;
    });
  }
  updateOnLocalSystemAfterChanges(String name, String address, String gender, String password) async
  {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    prefs.setString('address', address);
    prefs.setString('gender', gender);
    prefs.setString('password', password);
  }

  Future<void> updateJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    JWTToken = prefs.getString('JWTToken');
    print("jwtToken inside the WaitingCallScreen : $JWTToken");
  }

  Future<void> testingUpdateApi(String param, String data,) async {
    String testingApi = "https://dummyjson.com/products/1";
    final response = await http.put(
      Uri.parse(testingApi),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        param: data,
      }),
    );

    if (response.statusCode == 200) {
      print("operation successful.");
      final responseData = jsonDecode(response.body);
      print("printing the response $param:  ${responseData[param]}");
    } else {
      throw Exception('Failed to update album.');
    }
  }

  Future<void> updateDetailWithoutEmailPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
      return const PopScope(
        canPop: false,
        child:  AlertDialog(
          title:  Text("updating your details...",style: TextStyle(fontSize: 20),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
    });
    Future.delayed(const Duration(seconds: 3));
    print("$kApiUrlLink/api/User/Update/${_userId.toString()}");
    final response = await http.put(
      Uri.parse(
          "$kApiUrlLink/api/User/Update/${_userId.toString()}"), //${_userId.toString()}
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $JWTToken',
      },
      body: jsonEncode(<String, String>{
        "name":nameController.text,
        "address": addressController.text,
        "gender": dropdownValue,
      }),
    );
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      final responseData = jsonDecode(response.body);
      updateOnLocalSystemAfterChanges(responseData['name'],responseData['address'],responseData['gender'], responseData['password']);
      showDialog(context: context, builder: (context) => AlertDialog(
        title: const Text("Details updated successfully"),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: const Text("Okay"))
        ],
      ));
      print("operation successful.");
      //print("printing the response $param:  ${responseData[param]}");
    }
    else {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
        title: Text("Couldn't update the detail. Reason: ${response.body}"),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: const Text("Okay"))
        ],
      ));
      print("printing the response status code: ${response.statusCode}");
      print("response body: ${response.body.toString()}");
      throw Exception('Failed to update album.');
    }
  }
  Future<void> updateDetailWithEmailorPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
      return const PopScope(
        canPop: false,
        child: AlertDialog(
          title:  Text("updating your details...",style: TextStyle(fontSize: 20),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
    });
    Future.delayed(const Duration(seconds: 5));
    print("$kApiUrlLink/api/User/Update/${_userId.toString()}");
    final response = await http.put(
      Uri.parse(
          "$kApiUrlLink/api/User/Update/${_userId.toString()}"), //${_userId.toString()}
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $JWTToken',
      },
      body: jsonEncode(<String, String>{
        "name":nameController.text,
        "address": addressController.text,
        "gender": dropdownValue,
        "password":passwordController.text,
      }),
    );
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      final responseData = jsonDecode(response.body);
      updateOnLocalSystemAfterChanges(responseData['name'],responseData['address'],responseData['gender'], responseData['password']);
      showDialog(context: context, builder: (context) => AlertDialog(
        title: const Text("Details updated successfully"),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: const Text("Okay"))
        ],
      ));
      print("operation successful.");
      //print("printing the response $param:  ${responseData[param]}");
    }
    else {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Couldn't update the detail. Reason: ${response.body}"),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: const Text("Okay"))
            ],
          ));
      print("printing the response status code: ${response.statusCode}");
      print("response body: ${response.body.toString()}");
      throw Exception('Failed to update album.');
    }
  }
  @override
  void initState() {
    updateJwtToken();
    printUserSavedData();
    super.initState();
  }
  Color kTileColour = Colors.white70;
  bool _changePassword = true;
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 10,
        child: Container(
          // decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(15),
          //     gradient: LinearGradient(
          //         begin: Alignment.topLeft,
          //         end: Alignment.bottomRight,
          //         tileMode: TileMode.mirror,
          //         colors: [
          //           kAppThemeColor,
          //           Colors.white,
          //           kAppThemeColor,
          //         ])),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                   SizedBox(
                    height: 200,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Icon(
                        Icons.person,
                        color: kAppThemeColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (name) => validator.nameValidator(name),
                      inputFormatters: validator.nameFormatter,
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        filled: true,
                        fillColor: Colors.white70,
                        labelStyle: const TextStyle(
                            color: Colors.black,fontSize: 20,
                            fontWeight: FontWeight.bold),
                        enabledBorder: focusBorder(),
                        focusedBorder: focusBorder(),
                        disabledBorder: focusBorder(),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 3,
                            )),
                        errorBorder: const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 3,
                            )),
                        prefixIcon: const Icon(
                          Icons.account_circle,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (address) => validator.nameValidator(address),
                      inputFormatters: validator.addressFormatter,
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        filled: true,
                        fillColor: Colors.white70,
                        labelStyle: const TextStyle(
                            color: Colors.black,fontSize: 20,
                            fontWeight: FontWeight.bold),
                        enabledBorder: focusBorder(),
                        focusedBorder: focusBorder(),
                        disabledBorder: focusBorder(),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 3,
                            )),
                        errorBorder: const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 3,
                            )),
                        prefixIcon: const Icon(
                          Icons.location_on,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      validator: (value) => value == null ? "Please select your gender" : null,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      decoration: InputDecoration(
                        fillColor: Colors.white70,
                        filled: true,
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
                            )
                        ),
                        prefixIcon: const Icon(
                          Icons.wc
                        ),
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
                  ),
                  _changePassword ?
                  TextButton(
                      onPressed: (){
                    setState(() {
                      _changePassword = false;
                    });
                  }, child: const Text("Want to change your password?"))
                      :
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (password) => validator.passwordValidator(password),
                      inputFormatters: validator.passwordFormatter,
                      controller: passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        labelText: 'password',
                        filled: true,
                        fillColor: Colors.white70,
                        labelStyle: const TextStyle(
                            color: Colors.black,fontSize: 20,
                            fontWeight: FontWeight.bold),
                        enabledBorder: focusBorder(),
                        focusedBorder: focusBorder(),
                        disabledBorder: focusBorder(),
                        focusedErrorBorder: errorBorder(),
                        errorBorder: errorBorder(),
                        prefixIcon: const Icon(
                          Icons.password,
                          color: Colors.black,
                        ),
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          icon: Icon(
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),
                  ),

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
                        onPressed: () async {
                          if(_formKey.currentState!.validate())
                            {
                              if(_changePassword)
                                {
                                  await updateDetailWithoutEmailPassword();
                                }
                              else
                                {
                                  await updateDetailWithEmailorPassword();
                                }
                              await printUserSavedData();
                            }
                        },
                        child:  const Text(
                          'Update',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(4.0),
                  //   child: Material(
                  //     elevation: 10,
                  //     color: kTileColour,
                  //     borderRadius: BorderRadius.circular(10),
                  //     child: ListTile(
                  //       title: Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           const Icon(Icons.verified_user),
                  //           const SizedBox(
                  //             width: 40,
                  //           ),
                  //           _userId != null
                  //               ? Text(
                  //             _userId.toString(),
                  //             style: const TextStyle(
                  //                 color: Colors.black, fontSize: 20),
                  //           )
                  //               : const CircularProgressIndicator(),
                  //         ],
                  //       ),
                  //       onTap: () {
                  //         showDialog(
                  //           context: context,
                  //           builder: (context) => AlertDialog(
                  //             title: const Text("Can't update your Id"),
                  //             actions: [
                  //               TextButton(
                  //                   onPressed: (){
                  //                     Navigator.of(context).pop();
                  //                   },
                  //                   child: const Text("Okay")),
                  //             ],
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(4.0),
                  //   child: Material(
                  //     elevation: 10,
                  //     color: kTileColour,
                  //     borderRadius: BorderRadius.circular(10),
                  //     child: ListTile(
                  //       title: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.start,
                  //             children: [
                  //               const Icon(
                  //                   Icons.drive_file_rename_outline_outlined),
                  //               const SizedBox(
                  //                 width: 40,
                  //               ),
                  //               _name != null
                  //                   ? Text(
                  //                       _name!,
                  //                       style: const TextStyle(
                  //                           color: Colors.black,
                  //                           overflow: TextOverflow.ellipsis,
                  //                           fontSize: 20,
                  //                           fontWeight: FontWeight.bold),
                  //                     )
                  //                   : const Text(''),
                  //             ],
                  //           ),
                  //           const Icon(Icons.keyboard_arrow_right_outlined,color: Colors.black,),
                  //         ],
                  //       ),
                  //       onTap: () async  {
                  //         showDialog(
                  //             context: context,
                  //             barrierDismissible: false,
                  //             builder: (context) => AlertDialog(
                  //                   title: const Text("Change your name"),
                  //                   content: TextFormField(
                  //                     autovalidateMode: AutovalidateMode.onUserInteraction,
                  //                     validator: (name) => validator.nameValidator(name),
                  //                     inputFormatters: validator.nameFormatter,
                  //                     controller: nameController,
                  //                     decoration: InputDecoration(
                  //                       labelText: 'Name',
                  //                       labelStyle: const TextStyle(
                  //                           color: Colors.black,
                  //                           fontWeight: FontWeight.bold),
                  //                       enabledBorder: focusBorder(),
                  //                       focusedBorder: focusBorder(),
                  //                       disabledBorder: focusBorder(),
                  //                       focusedErrorBorder: const OutlineInputBorder(
                  //                           borderRadius:
                  //                           BorderRadius.all(Radius.circular(20)),
                  //                           borderSide: BorderSide(
                  //                             color: Colors.red,
                  //                             width: 3,
                  //                           )),
                  //                       errorBorder: const OutlineInputBorder(
                  //                           borderRadius:
                  //                           BorderRadius.all(Radius.circular(20)),
                  //                           borderSide: BorderSide(
                  //                             color: Colors.red,
                  //                             width: 3,
                  //                           )),
                  //                       prefixIcon: const Icon(
                  //                         Icons.drive_file_rename_outline_outlined,
                  //                         color: Colors.black,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   actions: [
                  //                     TextButton(
                  //                         onPressed: () async  {
                  //                           if(_formKey.currentState!.validate()) // if(true)
                  //                             {
                  //                             upDateSpecificData("name", nameController.text);
                  //                               updatingNewValue("name", nameController.text);
                  //                             //Navigator.of(updateDetailDialogContext!).pop();
                  //                               Navigator.of(context).pop();
                  //                             }
                  //                         },
                  //                         child: const Text("Save"),),
                  //                   ],
                  //                 ),
                  //         );
                  //         updatingDetailLoadingDialog();
                  //       },
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(4.0),
                  //   child: Material(
                  //     color: kTileColour,
                  //     borderRadius: BorderRadius.circular(10),
                  //     elevation: 10,
                  //     child: ListTile(
                  //       title: Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           const Icon(Icons.email),
                  //           const SizedBox(
                  //             width: 40,
                  //           ),
                  //           Flexible(
                  //             child: _mail != null
                  //                 ? Text(
                  //                     _mail!,
                  //                     style: const TextStyle(
                  //                         color: Colors.black,
                  //                         overflow: TextOverflow.ellipsis,
                  //                         fontSize: 20),
                  //                   )
                  //                 : Text('data'),
                  //           ),
                  //         ],
                  //       ),
                  //       onTap: () {
                  //         showDialog(
                  //           context: context,
                  //           builder: (ctx) => AlertDialog(
                  //             title: const Text('Change your email'),
                  //             content: TextFormField(
                  //               autovalidateMode:
                  //                   AutovalidateMode.onUserInteraction,
                  //               validator: (email) =>
                  //                   validator.emailValidator(email),
                  //               //inputFormatters: [ FilteringTextInputFormatter.allow(RegExp( r"[a-zA-Z0-9.@]+")) ],
                  //               controller: emailController,
                  //               decoration: InputDecoration(
                  //                 labelText: 'Email',
                  //                 labelStyle: const TextStyle(
                  //                     color: Colors.black,
                  //                     fontWeight: FontWeight.bold),
                  //                 enabledBorder: focusBorder(),
                  //                 focusedBorder: focusBorder(),
                  //                 disabledBorder: focusBorder(),
                  //                 focusedErrorBorder: const OutlineInputBorder(
                  //                     borderRadius:
                  //                         BorderRadius.all(Radius.circular(20)),
                  //                     borderSide: BorderSide(
                  //                       color: Colors.red,
                  //                       width: 3,
                  //                     )),
                  //                 errorBorder: const OutlineInputBorder(
                  //                     borderRadius:
                  //                         BorderRadius.all(Radius.circular(20)),
                  //                     borderSide: BorderSide(
                  //                       color: Colors.red,
                  //                       width: 3,
                  //                     )),
                  //                 prefixIcon: const Icon(
                  //                   Icons.email,
                  //                   color: Colors.black,
                  //                 ),
                  //               ),
                  //             ),
                  //             actions: [
                  //               TextButton(
                  //                   onPressed: () async {
                  //                     if (_formKey.currentState!.validate()) {
                  //                       await upDateSpecificData(
                  //                           "email", emailController.text);
                  //                       Navigator.of(context)
                  //                           .pushAndRemoveUntil(
                  //                               MaterialPageRoute(
                  //                                   builder: (context) =>
                  //                                       const LoginInScreen()),
                  //                               (route) => false);
                  //                     }
                  //                   },
                  //                   child: const Text("Save"))
                  //             ],
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(4.0),
                  //   child: Material(
                  //     elevation: 10,
                  //     color: kTileColour,
                  //     borderRadius: BorderRadius.circular(10),
                  //     child: ListTile(
                  //       title: Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           const Icon(Icons.phone),
                  //           const SizedBox(
                  //             width: 40,
                  //           ),
                  //           _contact != null
                  //               ? Flexible(
                  //                   child: Text(
                  //                     _contact!,
                  //                     style: const TextStyle(
                  //                         color: Colors.black,
                  //                         overflow: TextOverflow.ellipsis,
                  //                         fontSize: 20),
                  //                   ),
                  //                 )
                  //               : Text(''),
                  //         ],
                  //       ),
                  //       onTap: () {
                  //         showDialog(
                  //           context: context,
                  //           builder: (ctx) => customAlertDialog(
                  //             controller: phoneController,
                  //             ctx: ctx,
                  //             icon: Icons.phone,
                  //             shownText: 'Enter your contact no',
                  //             inputFormatters: [
                  //               FilteringTextInputFormatter.allow(RegExp(
                  //                   r"[a-zA-Z0-9.@]+")), // Allow only alphabets and space
                  //             ],
                  //             method: () {
                  //               upDateSpecificData(
                  //                   "contact", phoneController.text);
                  //               Navigator.push(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                       builder: (context) =>
                  //                           const LoginInScreen()));
                  //               Navigator.pushNamedAndRemoveUntil(
                  //                   context, '/login', (route) => false);
                  //             },
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(4.0),
                  //   child: Material(
                  //     elevation: 10,
                  //     color: kTileColour,
                  //     borderRadius: BorderRadius.circular(10),
                  //     child: ListTile(
                  //       title: Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           const Icon(Icons.place),
                  //           const SizedBox(
                  //             width: 40,
                  //           ),
                  //           _address != null
                  //               ? Flexible(
                  //                   child: Text(
                  //                     _address!,
                  //                     style: const TextStyle(
                  //                         color: Colors.black,
                  //                         overflow: TextOverflow.ellipsis,
                  //                         fontSize: 20),
                  //                   ),
                  //                 )
                  //               : const Text(''),
                  //         ],
                  //       ),
                  //       onTap: () {
                  //         showDialog(
                  //           context: context,
                  //           builder: (ctx) => customAlertDialog(
                  //             controller: addressController,
                  //             ctx: ctx,
                  //             icon: Icons.location_on,
                  //             shownText: 'Enter your address',
                  //             inputFormatters: [
                  //               FilteringTextInputFormatter.allow(RegExp(
                  //                   r"[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                  //             ],
                  //             method: () {
                  //               upDateSpecificData(
                  //                   "address", addressController.text);
                  //             },
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(4),
                  //   child: Material(
                  //     elevation: 10,
                  //     color: kTileColour,
                  //     borderRadius: BorderRadius.circular(10),
                  //     child: ListTile(
                  //       title: Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           const Icon(Icons.person_pin_sharp),
                  //           const SizedBox(
                  //             width: 40,
                  //           ),
                  //           _gender != null
                  //               ? Text(
                  //                   _gender!,
                  //                   style: TextStyle(
                  //                       color: Colors.black, fontSize: 20),
                  //                 )
                  //               : Text(''),
                  //         ],
                  //       ),
                  //       onTap: () {
                  //         showDialog(
                  //           context: context,
                  //           builder: (ctx) => customAlertDialog(
                  //             controller: genderController,
                  //             ctx: ctx,
                  //             icon: Icons.male,
                  //             shownText: 'Enter your gender',
                  //             inputFormatters: [
                  //               FilteringTextInputFormatter.allow(RegExp(
                  //                   r"[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                  //             ],
                  //             method: () {
                  //               upDateSpecificData(
                  //                   "gender", genderController.text);
                  //             },
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(4.0),
                  //   child: Material(
                  //     elevation: 10,
                  //     color: kTileColour,
                  //     borderRadius: BorderRadius.circular(10),
                  //     child: ListTile(
                  //       title: Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           Icon(Icons.password),
                  //           const SizedBox(
                  //             width: 40,
                  //           ),
                  //           Flexible(
                  //               child: _password != null
                  //                   ? const Text(
                  //                       "Password", //_password!,
                  //                       overflow: TextOverflow.ellipsis,
                  //                       style: TextStyle(
                  //                           color: Colors.black, fontSize: 20),
                  //                     )
                  //                   : Text('')),
                  //           // _password != null ? Text(_password!, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black, fontSize: 20),) : Text('')
                  //         ],
                  //       ),
                  //       onTap: () {
                  //         showDialog(
                  //           context: context,
                  //           builder: (ctx) => customAlertDialog(
                  //             controller: passwordController,
                  //             ctx: ctx,
                  //             icon: Icons.password,
                  //             shownText: 'Enter your password',
                  //             inputFormatters: [
                  //               FilteringTextInputFormatter.allow(RegExp(
                  //                   r"[a-zA-Z0-9.@]+")), // Allow only alphabets and space
                  //             ],
                  //             method: () {
                  //               upDateSpecificData(
                  //                   "password", passwordController.text);
                  //             },
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class customAlertDialog extends StatelessWidget {
  const customAlertDialog(
      {required this.ctx,
      super.key,
      required this.controller,
      required this.icon,
      required this.shownText,
      required this.inputFormatters,
      required this.method});
  final BuildContext ctx;
  final IconData icon;
  final String shownText;
  final List<TextInputFormatter> inputFormatters;
  final TextEditingController controller;
  final void Function() method;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Click save to save data."),
      content: customTextField(
        shownText,
        controller,
        icon,
        inputFormatters,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            method();
            Navigator.of(ctx).pop();
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.lightBlueAccent)),
          child: const Text(
            "click save.",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}