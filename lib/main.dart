import 'package:flutter/material.dart';
import 'package:newapp/CreateChannelPage.dart';

void main() => runApp( MaterialApp(home: panel()));

class panel extends StatelessWidget {
   panel({super.key});
  @override
  Widget build(BuildContext context) {
    return createChannelPage();
  }
}