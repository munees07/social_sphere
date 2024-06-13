// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_sphere/model/usermodel.dart';

class FollowService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<List<UserModel>> getUserFollowers(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('followers')
          .doc(userId)
          .collection('userFollowers')
          .get();

      List<String> followerIds = snapshot.docs.map((doc) => doc.id).toList();
 List<UserModel> followers = [];
    for (int i = 0; i < followerIds.length; i++) {
      String id = followerIds[i];
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(id).get();
      if (userDoc.exists) {
        followers.add(UserModel.fromJson(userDoc.data() as Map<String, dynamic>));
      }
    }

      return followers;
    } catch (e) {
      print("Error fetching followers: $e");
      return [];
    }
  }

  Future<void> followUser(String followUserId) async {
    String currentUserId = _auth.currentUser!.uid;

    await _firestore
        .collection('followers')
        .doc(currentUserId)
        .collection('userFollowers')
        .doc(followUserId)
        .set({'followed': true});

    await _firestore.collection('users').doc(followUserId).update({
      'followers': FieldValue.increment(1),
    });

    await _firestore.collection('users').doc(currentUserId).update({
      'following': FieldValue.increment(1),
    });
  }

  Future<void> unfollowUser(String unfollowUserId) async {
    String currentUserId = _auth.currentUser!.uid;

    await _firestore
        .collection('followers')
        .doc(currentUserId)
        .collection('userFollowers')
        .doc(unfollowUserId)
        .delete();

    await _firestore.collection('users').doc(unfollowUserId).update({
      'followers': FieldValue.increment(-1),
    });

    await _firestore.collection('users').doc(currentUserId).update({
      'following': FieldValue.increment(-1),
    });
  }

  Future<bool> isFollowing(String userId) async {
    String currentUserId = _auth.currentUser!.uid;
    DocumentSnapshot doc = await _firestore
        .collection('followers')
        .doc(currentUserId)
        .collection('userFollowers')
        .doc(userId)
        .get();
    return doc.exists;
  }

  Future<UserModel?> getUserData(BuildContext context, String userId) async {
    DocumentSnapshot doc =
        await _firestore.collection('users').doc(userId).get();
    return UserModel.fromJson(doc.data() as Map<String, dynamic>);
  }
}
