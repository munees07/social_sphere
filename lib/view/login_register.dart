import 'package:flutter/material.dart';
import 'package:social_sphere/view/login.dart';
import 'package:social_sphere/view/register.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {

  bool loginShow=true;

  void togglePages(){
    setState(() {
      loginShow=!loginShow;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(loginShow){
      return Login(onTap: togglePages);
    }else{
      return Register(onTap: togglePages,);
    }
  }
}