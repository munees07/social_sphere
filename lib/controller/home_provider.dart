import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  final Map<String, bool> likeState = {};
  final Map<String, int> likeCounts = {};

  bool isLiked(String postId) => likeState[postId] ?? false;
  int likeCount(String postId) => likeCounts[postId] ?? 0;

  void toggleLike(String postId) {
    likeState[postId] = !(likeState[postId] ?? false);
    likeCounts[postId] =
        (likeCounts[postId] ?? 0) + (likeState[postId]! ? 1 : -1);
    notifyListeners();
  }
}
