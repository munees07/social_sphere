import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignupProvider extends ChangeNotifier {
  File? pickedImage;
  ImagePicker image = ImagePicker();

  Future<void> pickImg() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    pickedImage = File(img!.path);
    notifyListeners();
  }

  void clearPickedImage() {
    pickedImage = null;
    notifyListeners();
  }
}