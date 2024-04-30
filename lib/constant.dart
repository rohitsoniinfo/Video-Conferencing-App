import 'package:flutter/material.dart';

String kAppId = "aaff3a381e23485090d0ae05ddc8ada1";

String kApiUrlLink = "http://test-env.eba-8minev3m.ap-south-1.elasticbeanstalk.com";
String kSignupApi = '/api/User/Create';
String kLoginApi = '/api/auth/login';
String kFetchingChannelUrl = ""; //"/api/User/${userId.toString()}?gender=male";
String kUpdateApi = '/api/User/Update/';

String kEmailVerificationOtpSend = '/api/Emailverification';
String kForgotPasswordOtpSend = '/api/SendEmail';
String kSetPassword = '/api/ChangePassword';

Color kAppThemeColor = const Color(0xff010536);

AppBar kAppBar = AppBar(
  backgroundColor: kAppThemeColor,
  title: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        height: 50,
        width: 100,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/byteBondLogo.png'))),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 40),
        child: Text(
          "byteBond",
          style: TextStyle(
              color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 30),
        ),
      )
    ],
  ),
);