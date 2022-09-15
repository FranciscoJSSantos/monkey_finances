import 'package:flutter/material.dart';

const kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'Roboto',
);

const kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'Roboto',
);

final kBoxDecorationStyle = BoxDecoration(
  color: const Color(0xFF263238),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final ButtonStyle styledButtonLogin = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    textStyle: const TextStyle(fontSize: 20),
    elevation: 5.0,
    padding: const EdgeInsets.all(20.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)));
