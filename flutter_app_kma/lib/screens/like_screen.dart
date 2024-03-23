import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/chat.dart';
import 'package:flutter_app/screens/detail_like.dart';
import 'package:flutter_app/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<LikeScreen> createState() => _UserChatState();
}

class _UserChatState extends State<LikeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? currentUid;

  @override
  void initState() {
    super.initState();
    getCurrentUID();
  }

  String? getCurrentUID() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liked posts"),
        backgroundColor: mobileBackgroundColor,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('posts')
            // .where('likes',
            // isEqualTo: getCurrentUID() 
            // )
            .where('likes', arrayContains: getCurrentUID())
            // .orderBy('datePublished')
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data;
          if (data == null) {
            // Xử lý khi dữ liệu là null
            return const Center(
              child: Text('No data found'),
            );
          }

          return MasonryGridView.count(
            crossAxisCount: 3,
            itemCount: data.docs.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap:() {
                Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>  DetailLike(
                          postID: data.docs[index].id,
                        ),
                      ),
                    );
              },
              child: Image.network(
                data.docs[index]['postUrl'],
                fit: BoxFit.cover,
              ),
            ),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          );
        },
      ),
    );
  }
}
