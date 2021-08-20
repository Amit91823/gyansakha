import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MassegesScreen extends StatefulWidget {
  const MassegesScreen({Key? key}) : super(key: key);

  @override
  _MassegesScreenState createState() => _MassegesScreenState();
}

class _MassegesScreenState extends State<MassegesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: FirebaseAuth.instance.currentUser?.uid,
              ),
            ),
          ),
          Container(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: FirebaseAuth.instance.currentUser?.uid,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
