// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:social_sphere/service/follow_services.dart';
import 'package:social_sphere/service/user_services.dart';

class AllUserPage extends StatelessWidget {
  const AllUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    FollowService followService = FollowService();
    return Scaffold(
      body: StreamBuilder(
        stream: UserService().getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("error code"),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final data = snapshot.data![index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: InkWell(
                    onTap: () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) =>
                      //       Profile(userId: data.uid!),
                      // ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.lightBlueAccent.withOpacity(0.1)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(15),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(data.image.toString()),
                        ),
                        trailing: FutureBuilder<bool>(
                          future:
                              followService.isFollowing(data.uid.toString()),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            bool isFollowing = snapshot.data!;
                            return ElevatedButton(
                              style: ButtonStyle(
                                  shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                  foregroundColor: isFollowing
                                      ? const WidgetStatePropertyAll(Colors.black)
                                      : const WidgetStatePropertyAll(Colors.white),
                                  backgroundColor: isFollowing
                                      ? const WidgetStatePropertyAll(Colors.white)
                                      : const WidgetStatePropertyAll(Colors.black)),
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
                              child: Text(isFollowing ? 'Unfollow' : 'Follow'),
                            );
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
