import 'package:flutter/material.dart';
import 'package:monkey_finances/screens/login.dart';
import 'package:monkey_finances/screens/forgot_password.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monkey Finances',
      debugShowCheckedModeBanner: false,
      home: ForgotPasswordScreen(),
    );
  }
}