import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:social_sphere/widgets/button_widget.dart';
import 'package:social_sphere/widgets/textfieled_widget.dart';
import 'package:social_sphere/widgets/tile_widget.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passworController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Center(
              child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const Gap(25),
            const Text(
              'Social Sphere',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
            ),
            const Gap(30),
            const Icon(
              Icons.lock,
              size: 80,
            ),
            const Gap(35),
            Text(
              'Welcome back you\'ve been missed!',
              style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            const Gap(40),
            TextFieldWidget(
              controller: emailController,
              hintText: 'Email',
              obsecureText: false,
            ),
            const Gap(15),
            TextFieldWidget(
              controller: passworController,
              hintText: 'Password',
              obsecureText: true,
            ),
            const Gap(5),
            Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.grey[700]),
                )),
            const Gap(30),
            ButtonWidget(
              onTap: () {},
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[600],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SquareTile(imagePath: 'assets/images/google.png'),
                SizedBox(width: 25),
                SquareTile(imagePath: 'assets/images/github.png')
              ],
            ),
          ],
        ),
      ))),
    );
  }
}
