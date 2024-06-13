
// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_sphere/service/auth_services.dart';

class FirebaseAuthContriller extends ChangeNotifier {
  TextEditingController passwordCtrl = TextEditingController();
  AuthServices service = AuthServices();

  Future signup(BuildContext context, String username, String email,
      String password, String imageUrl) async {
    try {
      await service.signupWithEmailAndPassword(context, username, email, password, imageUrl);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future signin(BuildContext context, String email, String password) async {
    try {
      await service.signinWithEmailAndPassword(context, email, password);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
    notifyListeners();
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  
}