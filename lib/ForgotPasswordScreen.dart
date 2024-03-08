import 'package:flutter/material.dart';
import 'package:newapp/Component/SignUpScreenUiComponent.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TopBottomDesign(
            true,
            const BorderRadius.only(bottomRight: Radius.circular(200)),
            const BorderRadius.only(bottomLeft: Radius.circular(200)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                customTextField(
                    'Contact or Email ', passwordController, Icons.password,
                  [

                  ]
                ),
                const SizedBox(height: 10),

                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.blue),
                    //fixedSize: MaterialStateProperty.resolveWith((states) => Size(100, 30))
                  ),
                  onPressed: (){},
                  child: const Text(
                    'send otp ',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),

              ],
            ),
          ),

          TopBottomDesign(
            true,
            const BorderRadius.only(topRight: Radius.circular(200)),
            const BorderRadius.only(topLeft: Radius.circular(200)),
          ),

        ],
      ),
    ));
  }
}
