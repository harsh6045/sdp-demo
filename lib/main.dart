import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ytbot/firebase/firebase_options.dart';
import 'package:ytbot/login/auth_page.dart';
import 'package:ytbot/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'name-here',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
//main file