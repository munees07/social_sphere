import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:social_sphere/controller/home_provider.dart';
import 'package:social_sphere/controller/signup_provider.dart';
import 'package:social_sphere/model/postimage_model.dart';
import 'package:social_sphere/service/image_service.dart';
import 'package:social_sphere/view/comment.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SOCIAL SPHERE'),
          actions: [
            IconButton(
                onPressed: () {
                  signOut();
                  Provider.of<SignupProvider>(context, listen: false).signout();
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: StreamBuilder(
          stream: ImagePostService().getPost(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              List<QueryDocumentSnapshot<ImagePostModel>> postRef =
                  snapshot.data?.docs ?? [];
              if (postRef.isEmpty) {
                return const Center(
                  child: Text("No data available",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                );
              }
              return ListView.builder(
                itemCount: postRef.length,
                itemBuilder: (context, index) {
                  final data = postRef[index].data();
                  final postId = postRef[index].id;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.grey[100],
                      elevation: 10,
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                        backgroundImage:
                                            getImage(data.userImage)),
                                    const Gap(20),
                                    Text(data.username ?? 'No name')
                                  ],
                                ),
                              ),
                              SizedBox(
                                child: Image(
                                    image: NetworkImage(data.image.toString()),
                                    fit: BoxFit.cover),
                              ),
                              const Gap(10),
                              Row(
                                children: [
                                  const Gap(5),
                                  Text(data.description.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Consumer<HomeProvider>(
                                    builder: (context, homeController, _) {
                                      final isLiked =
                                          homeController.isLiked(postId);

                                      final likeCount =
                                          homeController.likeCount(postId);
                                      return Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              homeController.toggleLike(postId);
                                            },
                                            icon: Icon(
                                                isLiked
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: isLiked
                                                    ? Colors.red
                                                    : Colors.black),
                                          ),
                                          Text('$likeCount likes'),
                                          const Gap(240),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CommentPage(
                                                              postId: postId)));
                                            },
                                            icon: const Icon(
                                                size: 27,
                                                CupertinoIcons.chat_bubble),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  ImageProvider getImage(String? imageUrl) {
    if (imageUrl != null &&
        imageUrl.isNotEmpty &&
        Uri.tryParse(imageUrl)?.hasAbsolutePath == true) {
      return NetworkImage(imageUrl);
    } else {
      return const AssetImage('assets/images/avatar-3814049_1920.png');
    }
  }
}
