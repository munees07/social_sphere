import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:social_sphere/model/postimage_model.dart';
import 'package:social_sphere/model/usermodel.dart';
import 'package:social_sphere/service/follow_services.dart';
import 'package:social_sphere/service/image_service.dart';
import 'package:social_sphere/widgets/loading.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: FutureBuilder<UserModel?>(
            future: FollowService().getUserData(context, user),
            builder: (context, snapshot) {
              UserModel? user = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Gap(45),
                      Text(user?.username.toString().toUpperCase() ?? "",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Gap(30),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                              maxRadius: 40,
                              backgroundImage: getImage(user?.image)),
                          Column(
                            children: [
                              const Text("FOLLOWERS"),
                              Text(user?.followers.toString() ?? "")
                            ],
                          ),
                          Column(
                            children: [
                              const Text("FOLLOWING"),
                              Text(user?.following.toString() ?? "")
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot<ImagePostModel>>(
                      stream: ImagePostService().getPostUser(
                          ImagePostModel(image: "", uid: user?.uid),
                          user?.uid ?? ""),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(child: spinner);
                        }

                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('No posts found.'));
                        }

                        final posts = snapshot.data!.docs
                            .map((doc) => doc.data())
                            .toList();
                        List<QueryDocumentSnapshot<ImagePostModel>> postRef =
                            snapshot.data?.docs ?? [];

                        return GridView.builder(
                          padding: const EdgeInsets.only(left: 10, top: 20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 1,
                            childAspectRatio: 1,
                          ),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            final id = postRef[index].id;
                            return Stack(
                              children: [
                                Card(
                                  elevation: 2,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Image.network(
                                            post.image.toString(),
                                            fit: BoxFit.cover),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  top: 0,
                                  child: IconButton(
                                      onPressed: () {
                                        ImagePostService().deleteImage(
                                            post.image.toString(), context);
                                        ImagePostService().deletePost(id);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.redAccent[200],
                                      )),
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
      ),
    );
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
