import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:social_sphere/service/otp_services.dart';
import 'package:social_sphere/view/auth.dart';
import 'package:social_sphere/widgets/button_widget.dart';

class PhoneOtpPage extends StatelessWidget {
  PhoneOtpPage({super.key});
  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController phoneCtrl = TextEditingController();
    TextEditingController otpCtrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue[100]),
      backgroundColor: Colors.blue[100],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Gap(180),
            Text(
              'Login with Phone!',
              style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const Gap(100),
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: phoneCtrl,
                  decoration: InputDecoration(
                      prefix: const Text("+91"),
                      prefixIcon: const Icon(Icons.phone),
                      labelText: "Enter Phone Number",
                      fillColor: Colors.lightBlueAccent.withOpacity(0.2),
                      filled: true,
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                  validator: (value) {
                    if (value!.length != 10) return "invalid phone number";
                    return null;
                  },
                ),
              ),
            ),
            const Gap(20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonWidget(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      PhoneOtpAuth.sentOtp(
                          phone: phoneCtrl.text,
                          errorStep: () => ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      content: Text(
                                "Error in sending otp ",
                              ))),
                          nextStep: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("otp verification"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("Enter 6 digit Otp"),
                                    const Gap(15),
                                    Form(
                                      key: formKey1,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: otpCtrl,
                                        decoration: InputDecoration(
                                            hintText: 'Enter Phone',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[500]),
                                            fillColor: Colors.lightBlueAccent
                                                .withOpacity(0.2),
                                            filled: true,
                                            enabledBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey)),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey))),
                                        validator: (value) {
                                          if (value!.length != 6) {
                                            return "invalid otp number";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        if (formKey1.currentState!.validate()) {
                                          PhoneOtpAuth.loginWithOtp(
                                                  otp: otpCtrl.text)
                                              .then((value) {
                                            if (value == "Success") {
                                              Navigator.pop(context);
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                builder: (context) =>
                                                    const AuthPage(),
                                              ));
                                            }
                                          });
                                        }
                                      },
                                      child: const Text("Submit"))
                                ],
                              ),
                            );
                          });
                    }
                  },
                  text: 'Send Otp'),
            )
            // ElevatedButton(
            //     onPressed: () {

            //     },
            //     style: const ButtonStyle(
            //         elevation: WidgetStatePropertyAll(25),
            //         backgroundColor: WidgetStatePropertyAll(Colors.black)),
            //     child: const Text("Send Otp"))
          ],
        ),
      ),
    );
  }
}
