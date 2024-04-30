import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:newapp/MainApp/RandomCall.dart';
import 'package:newapp/constant.dart';

class CallEndedScreen extends StatefulWidget {
  const CallEndedScreen({super.key, required this.callDuration});
  final int callDuration;
  @override
  State<CallEndedScreen> createState() => _CallEndedScreenState();
}

class _CallEndedScreenState extends State<CallEndedScreen> {
  int _callDuration = 0;
  String text = "";
  @override
  void initState() {
    // TODO: implement initState
    _callDuration = widget.callDuration;
    if (_callDuration < 60) {
      text = "seconds";
    } else {
      _callDuration = _callDuration ~/ 60;
      text = "minutes";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const RandomCall()),
            (route) => false);
      },
      child: Scaffold(
        appBar: kAppBar,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 70,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Call Ended",
                  style: TextStyle(
                      color: kAppThemeColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  "you talked for ${_callDuration.toString()} $text",
                  style: TextStyle(color: kAppThemeColor, fontSize: 20),
                ),
              ),
              Card(
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
                          ])),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "✨ Thanks for connecting! We hope you enjoyed your call. Find someone new to talk to?",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                          width: 150,
                          height: 150,
                          child: FittedBox(
                              fit: BoxFit.fill,
                              child: Icon(
                                Icons.emoji_emotions,
                                color: Colors.yellow,
                              ))),
                      TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                  "Enter the reason for report?",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                content: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      autocorrect: true,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); 
                                      },
                                      child: const Text("Send")),
                                ],
                              ),
                            );
                          },
                          child: const Text("report?")),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const RandomCall()),
                          (route) => false);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(kAppThemeColor),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Next Call",
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
