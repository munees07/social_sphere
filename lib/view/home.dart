import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
   Home({super.key});

  final user= FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                signOut();
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
