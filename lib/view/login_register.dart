import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_sphere/controller/signup_provider.dart';
import 'package:social_sphere/view/login.dart';
import 'package:social_sphere/view/register.dart';

class LoginOrRegister extends StatelessWidget {
  const LoginOrRegister({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignupProvider>(context);
    if (provider.loginShow) {
      return Login(onTap: () {
        togglePages(context);
      });
    } else {
      return Register(onTap: () {
        togglePages(context);
      });
    }
  }

  void togglePages(BuildContext context) {
    Provider.of<SignupProvider>(context, listen: false).pageToggle();
  }
}
