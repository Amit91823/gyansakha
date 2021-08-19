import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/Material.dart';
import 'package:gyansakha/screens/HomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(HomeScreen());
}
