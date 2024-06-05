import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  final Map<String, bool> _likeStates = {};
  final Map<String, int> _likeCounts = {};

  bool isLiked(String postId) => _likeStates[postId] ?? false;
  int likeCount(String postId) => _likeCounts[postId] ?? 0;

  void toggleLike(String postId) {
    _likeStates[postId] = !(_likeStates[postId] ?? false);
    _likeCounts[postId] =
        (_likeCounts[postId] ?? 0) + (_likeStates[postId]! ? 1 : -1);
    notifyListeners();
  }
}
