// ignore_for_file: empty_catches

import 'package:firebase_auth/firebase_auth.dart';

class PhoneOtpAuth {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static String verifyId = "";
  static Future sentOtp({
    required String phone,
    required Function errorStep,
    required Function nextStep,
  }) async {
    try {
      await auth
          .verifyPhoneNumber(
        timeout: const Duration(seconds: 30),
        phoneNumber: "+91$phone",
        verificationCompleted: (phoneAuthCredential) async {
          return;
        },
        verificationFailed: (error) {
          return;
        },
        codeSent: (verificationId, forceResendingToken) async {
          verifyId = verificationId;
          nextStep();
        },
        codeAutoRetrievalTimeout: (verificationId) async {
          return;
        },
      )
          .onError(
        (error, stackTrace) {
          errorStep();
        },
      );
    } catch (e) {}
  }

  static Future loginWithOtp({required String otp}) async {
    final credential =
        PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp);

    try {
      final user = await auth.signInWithCredential(credential);
      if (user.user != null) {
        return "Success";
      } else {
        return "Enter in otp login";
      }
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }
}
