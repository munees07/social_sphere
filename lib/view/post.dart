// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_sphere/controller/image_provider.dart';

class PostScreen extends StatelessWidget {
  String? email;
  PostScreen({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final provider = Provider.of<ImagesProvider>(context, listen: false);
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
                            provider.pickImg();
                          },
                          child: Container(
                            height: height * 0.4,
                            width: width,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: provider.descriptionCtrl,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: "Description",
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      provider.addPst(context, false);
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
                    child: const Text("Post"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
