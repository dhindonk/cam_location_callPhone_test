import 'package:flutter/material.dart';

import 'direct_phone_number.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CallPage(),
    );
  }
}