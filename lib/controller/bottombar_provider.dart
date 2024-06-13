import 'package:flutter/material.dart';
import 'package:social_sphere/view/follow.dart';
import 'package:social_sphere/view/home.dart';
import 'package:social_sphere/view/post.dart';
import 'package:social_sphere/view/profile.dart';

class BottomBarProvider extends ChangeNotifier {
  int currentIndex = 0;
  onTap(int index) {
    currentIndex = index;
    notifyListeners();
  }

  final List pages = [
    const Home(),
    PostScreen(),
    const AllUserPage(),
    const Profile()
  ];
}
