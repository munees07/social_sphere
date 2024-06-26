// ignore_for_file: use_build_context_synchronously, avoid_print, must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:social_sphere/controller/signup_provider.dart';
import 'package:social_sphere/service/auth_services.dart';
import 'package:social_sphere/view/bottomnav.dart';
import 'package:social_sphere/view/otp_verifiy.dart';
import 'package:social_sphere/widgets/button_widget.dart';
import 'package:social_sphere/widgets/textfieled_widget.dart';
import 'package:social_sphere/widgets/tile_widget.dart';

class Login extends StatelessWidget {
  final Function()? onTap;
  Login({super.key, this.onTap});

  final emailController = TextEditingController();

  final passworController = TextEditingController();

  bool isSigning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.2),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Center(
                child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const Gap(25),
              const Text('Social Sphere',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35)),
              const Gap(30),
              const Icon(Icons.login, size: 80),
              const Gap(35),
              Text('Welcome back!',
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              const Gap(40),
              TextFieldWidget(
                  controller: emailController,
                  hintText: 'Email',
                  obsecureText: false),
              const Gap(15),
              TextFieldWidget(
                  controller: passworController,
                  hintText: 'Password',
                  obsecureText: true),
              const Gap(10),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text('Forgot Password?',
                      style: TextStyle(color: Colors.grey[700]))),
              const Gap(25),
              ButtonWidget(
                  text: 'Sign In',
                  onTap: () {
                    login(context);
                  }),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(thickness: 0.5, color: Colors.grey[600]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('Or continue with',
                          style: TextStyle(color: Colors.grey[700])),
                    ),
                    Expanded(
                      child: Divider(thickness: 0.5, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(
                      onTap: () => AuthServices().signInWithGoogle(),
                      imagePath: 'assets/images/google.png'),
                  const SizedBox(width: 25),
                  SquareTile(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PhoneOtpPage(),
                          )),
                      imagePath: 'assets/images/phone.png')
                ],
              ),
              const Gap(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      'Register now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ))),
      ),
    );
  }

  void login(BuildContext context) async {
    final provider = Provider.of<SignupProvider>(context, listen: false);
    provider.isSignedIn();

    AuthServices auth = AuthServices();
    String email = emailController.text;
    String password = passworController.text;

    User? user = await auth.signinWithEmailAndPassword(
      context,
      email,
      password,
    );

    provider.isSignedIn();
    if (user != null) {
      print("user successfully logined");
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const BottomNav(),
        ),
        (route) => false,
      );
    } else {
      print("some error happend");
    }
  }
}
