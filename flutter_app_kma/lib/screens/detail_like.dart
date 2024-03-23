import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/colors.dart';
import 'package:flutter_app/utils/global_variable.dart';
import 'package:flutter_app/widgets/post_card.dart';

class DetailLike extends StatefulWidget {
  final String postID;

  const DetailLike({
    Key? key,
    required this.postID,
  }) : super(key: key);

  @override
  State<DetailLike> createState() => _DetailLikeState();
}

class _DetailLikeState extends State<DetailLike> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liked"),
        backgroundColor: mobileBackgroundColor,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postID) // Use widget.postID to get the specific post
            .get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('Post not found'),
            );
          }

          var post = snapshot.data!.data();

          return PostCard(snap: post); // Assuming you have a PostCard widget
        },
      ),
    );
  }
}
