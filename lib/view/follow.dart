// ignore_for_file: invalid_use_of_protected_member

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_sphere/model/usermodel.dart';
import 'package:social_sphere/service/follow_services.dart';
import 'package:social_sphere/service/user_services.dart';
import 'package:social_sphere/widgets/loading.dart';

class AllUserPage extends StatelessWidget {
  const AllUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    FollowService followService = FollowService();
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(title: const Text('SOCIAL SPHERE')),
      body: StreamBuilder(
        stream: UserService().getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("error code"),
            );
          } else {
            List<UserModel> users = (snapshot.data as List<UserModel>)
                .where((user) => user.uid != currentUserId)
                .toList();
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final data = users[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withOpacity(0.1)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(15),
                        leading: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage(data.image.toString())),
                        trailing: FutureBuilder<bool>(
                          future:
                              followService.isFollowing(data.uid.toString()),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return spinner;
                            }
                            bool isFollowing = snapshot.data!;
                            return ElevatedButton(
                                style: ButtonStyle(
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                    foregroundColor: isFollowing
                                        ? const WidgetStatePropertyAll(
                                            Colors.black)
                                        : const WidgetStatePropertyAll(
                                            Colors.white),
                                    backgroundColor: isFollowing
                                        ? const WidgetStatePropertyAll(
                                            Colors.white)
                                        : const WidgetStatePropertyAll(
                                            Colors.black)),
                                onPressed: () async {
                                  if (isFollowing) {
                                    await followService
                                        .unfollowUser(data.uid.toString());
                                  } else {
                                    await followService
                                        .followUser(data.uid.toString());
                                  }
                                  (context as Element).reassemble();
                                },
                                child:
                                    Text(isFollowing ? 'Unfollow' : 'Follow'));
                          },
                        ),
                        title: Text(data.username.toString()),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
