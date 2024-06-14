// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_sphere/controller/comment_provider.dart';
import 'package:social_sphere/model/comment_model.dart';
import 'package:social_sphere/service/follow_services.dart';
import 'package:social_sphere/widgets/loading.dart';

class CommentPage extends StatelessWidget {
  String postId;
  CommentPage({super.key, required this.postId});
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CommentProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: StreamBuilder(
          stream: provider.getComments(postId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: spinner);
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text(
                'Something went wrong',
              ));
            } else if (snapshot.data?.isNotEmpty != snapshot.hasData) {
              return const Center(
                child: Text(
                  "No commets",
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(data.image),
                            ),
                            const Gap(10),
                            Column(
                              children: [
                                Text(
                                  data.username,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  data.commentText.toString(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          formatTimestamp(data.timestamp),
                        )
                      ],
                    ),
                  );
                },
              );
            }
          }),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: commentController,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () {
                    addComment(context);
                  },
                  icon: const Icon(Icons.send)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
        ),
      ),
    );
  }

  addComment(BuildContext context) async {
    final provider = Provider.of<CommentProvider>(context, listen: false);
    final username = await FollowService().getUserData(context, currentUser);
    CommentModel ctModel = CommentModel(
        postId: postId,
        userId: currentUser,
        commentText: commentController.text,
        timestamp: Timestamp.now(),
        username: username?.username ?? "",
        image: username?.image ?? "");
    commentController.clear();
    await provider.addComment(ctModel);
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('MM-dd – kk:mm').format(dateTime);
  }
}
