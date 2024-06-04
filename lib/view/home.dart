import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                signOut();
                setState(() {});
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Text('Logged as: ${user.email!}'),
      ),
    );
  }
}

void signOut() async {
  await FirebaseAuth.instance.signOut();
}
