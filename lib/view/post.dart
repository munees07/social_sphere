// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_sphere/controller/image_provider.dart';
import 'package:social_sphere/model/image_post_model.dart';
import 'package:social_sphere/service/image_service.dart';

class PostScreen extends StatelessWidget {
  String? email;
  PostScreen({super.key, this.email});

  TextEditingController descriptionCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: PopScope(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Create Post"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Consumer<ImagesProvider>(builder: (context, pro, _) {
                    return FutureBuilder<File?>(
                      future: Future.value(pro.pickedImage),
                      builder: (context, snapshot) {
                        return GestureDetector(
                          onTap: () {
                            Provider.of<ImagesProvider>(context, listen: false)
                                .pickImg();
                          },
                          child: Container(
                            height: height * 0.4,
                            width: width,
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
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
                                      "Select a Image",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        );
                      },
                    );
                  }),
                  const SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {

                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     foregroundColor: Colors.white,
                  //     backgroundColor: Colors.black,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //   ),
                  //   child: const Text("Add Picture"),
                  // ),
                  // const SizedBox(height: 20),
                  TextFormField(
                    controller: descriptionCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      add(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  add(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    ImagePostService services = ImagePostService();
    final imageProvider = Provider.of<ImagesProvider>(context, listen: false);

    if (imageProvider.pickedImage != null) {
      await services.addImage(File(imageProvider.pickedImage!.path), context);

      ImagePostModel imModel = ImagePostModel(
          image: services.url, description: descriptionCtrl.text, uid: user);

      await services.addPost(imModel);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image.")),
      );
    }
    imageProvider.clearPickedImage();
    descriptionCtrl.clear();
  }
}
