import 'package:flutter/material.dart';
import 'package:gyansakha/screens/SwapScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SwapScreen(),
      theme: ThemeData(fontFamily: 'Hahmlet'),
      debugShowCheckedModeBanner: false,
    );
  }
}
