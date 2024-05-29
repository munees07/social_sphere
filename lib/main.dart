import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_sphere/firebase_options.dart';
import 'package:social_sphere/view/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Exo2'),
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
    );
  }
}
