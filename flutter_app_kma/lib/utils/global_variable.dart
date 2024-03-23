import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/add_post_screen.dart';
import 'package:flutter_app/screens/feed_screen.dart';
import 'package:flutter_app/screens/like_screen.dart';
import 'package:flutter_app/screens/profile_screen.dart';
import 'package:flutter_app/screens/search_screen.dart';

const webScreenSize = 600;
String getCurrentUID() {
  final User? user = FirebaseAuth.instance.currentUser;
  return user?.uid?? '';
}

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  //Center(child: Text(' notifications')),
  LikeScreen(),
  ProfileScreen(
    uid: getCurrentUID(),
  ),
];
