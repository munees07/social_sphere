// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_sphere/model/usermodel.dart';

class AuthServices{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String imageName = DateTime.now().microsecondsSinceEpoch.toString();
  String url = "";
  Reference firebaseStorage = FirebaseStorage.instance.ref();

  String collectionRef = "users";
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference<UserModel> postImgRef =
      firestore.collection(collectionRef).withConverter<UserModel>(
            fromFirestore: (snapshot, options) =>
                UserModel.fromJson(snapshot.data() ?? {}),
            toFirestore: (value, options) => value.toJson(),
          );

  Future<void> addImage(File image, BuildContext context) async {
    Reference imageFolder = firebaseStorage.child("images");
    Reference uploadedImage = imageFolder.child("$imageName.jpg");
    try {
      await uploadedImage.putFile(image);
      url = await uploadedImage.getDownloadURL();
    } catch (e) {
      showSnackBar(context, 'Failed to upload image: ${e.toString()}');
    }
  }

  Future updateImage(
      String imageUrl, File updateImage, BuildContext context) async {
    try {
      Reference editImageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await editImageRef.putFile(updateImage);
      String newUrl = await editImageRef.getDownloadURL();
      return newUrl;
    } catch (e) {
      showSnackBar(context, 'Failed to update image: ${e.toString()}');
      return null;
    }
  }

  Future<void> deleteImage(String imageUrl, BuildContext context) async {
    try {
      Reference delete = FirebaseStorage.instance.refFromURL(imageUrl);
      await delete.delete();
    } catch (e) {
      showSnackBar(context, 'Failed to delete image: ${e.toString()}');
    }
  }

  Future<User?> signupWithEmailAndPassword(
      BuildContext context, String username, String email, String password, String imageUrl) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = credential.user;

      if (user != null) {
        UserModel newUser = UserModel(
          username: username,
          email: email,
          uid: user.uid,
          password: password,
          image: imageUrl,
        );

        await _firestore.collection('users').doc(user.uid).set(newUser.toJson());

        await sendEmailVerification(context);

        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      return null;
    }
  }

  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      await _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, "Email verification sent");
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  Future<User?> signinWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (!_auth.currentUser!.emailVerified) {
        await sendEmailVerification(context);
      }
      return credential.user;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      return null;
    }
  }

  void showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

  signInWithGoogle()async{
    final GoogleSignInAccount? gUser=await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth=await gUser!.authentication;

    final credential=GoogleAuthProvider.credential(accessToken: gAuth.accessToken,idToken: gAuth.idToken);

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  signInWithGit()async{
    
  }


  

}