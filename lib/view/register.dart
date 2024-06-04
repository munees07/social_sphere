// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:social_sphere/controller/signup_provider.dart';
import 'package:social_sphere/service/auth_services.dart';
import 'package:social_sphere/view/bottomnav.dart';
import 'package:social_sphere/widgets/button_widget.dart';
import 'package:social_sphere/widgets/textfieled_widget.dart';
import 'package:social_sphere/widgets/tile_widget.dart';

class Register extends StatefulWidget {
  final Function()? onTap;
  const Register({super.key, required this.onTap});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthServices _auth = AuthServices();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  File? _selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.withOpacity(0.2),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Center(
                child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const Gap(15),
              const Text(
                'Social Sphere',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
              const Gap(10),
              Text(
                'Let\'s create an account!',
                style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
              const Gap(10),
              Consumer<SgupPageController>(builder: (context, pro, _) {
                return FutureBuilder<File?>(
                  future: Future.value(pro.pickedImage),
                  builder: (context, snapshot) {
                    _selectedImage = snapshot.data;
                    return Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(70),
                        image: snapshot.data != null
                            ? DecorationImage(
                                image: FileImage(snapshot.data!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: snapshot.data == null
                          ? Center(
                              child: Text(
                                "No image",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : null,
                    );
                  },
                );
              }),
              const Gap(15),
              ElevatedButton(
                onPressed: () {
                  Provider.of<SgupPageController>(context, listen: false)
                      .pickImg();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Add Picture"),
              ),
              const Gap(10),
              TextFieldWidget(
                controller: emailController,
                hintText: 'Email',
                obsecureText: false,
              ),
              const Gap(15),
              TextFieldWidget(
                controller: usernameController,
                hintText: 'UserName',
                obsecureText: false,
              ),
              const Gap(15),
              TextFieldWidget(
                controller: passwordController,
                hintText: 'Password',
                obsecureText: true,
              ),
              const Gap(20),
              ButtonWidget(
                  text: 'Sign Up',
                  onTap: () {
                    signUp();
                  }),
              const SizedBox(height: 20),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(
                      onTap: () => AuthServices().signInWithGoogle(),
                      imagePath: 'assets/images/google.png'),
                  const SizedBox(width: 25),
                  SquareTile(
                      onTap: () => AuthServices().signInWithGit(),
                      imagePath: 'assets/images/github.png')
                ],
              ),
              const Gap(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Login now',
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

  void signUp() async {
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    if (_selectedImage != null) {
      await _auth.addImage(_selectedImage!, context);
      String imageUrl = _auth.url;

      User? user = await _auth.signupWithEmailAndPassword(
          context, username, email, password, imageUrl);

      if (user != null) {
        print("User is successful");
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const BottomNav(),
        ));
      }
    } else {
      _auth.showSnackBar(context, "Please select an image");
    }
  }
}
