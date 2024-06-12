
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_sphere/model/postimage_model.dart';
import 'package:social_sphere/model/usermodel.dart';
import 'package:social_sphere/service/follow_services.dart';
import 'package:social_sphere/service/image_service.dart';

class ImagesProvider extends ChangeNotifier {
  TextEditingController descriptionCtrl = TextEditingController();
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

  addPst(BuildContext context,isLiked) async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    UserModel? username = await FollowService().getUserData(context,user);
    ImagePostService services = ImagePostService();
    // final imageProvider = Provider.of<ImagesProvider>(context, listen: false);

    if (pickedImage != null) {
      await services.addImage(File(pickedImage!.path), context);

      ImagePostModel imModel = ImagePostModel(
          image: services.url,
          description: descriptionCtrl.text,
          uid: user,
          username: username!.username.toString(),
          userImage: username.image,
          isLiked:isLiked);

      await services.addPost(imModel);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image.")),
      );
    }
    clearPickedImage();
    descriptionCtrl.clear();
  }
}
