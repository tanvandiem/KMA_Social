import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/user.dart';

import 'package:flutter_app/screens/user_screen.dart';
import 'package:flutter_app/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Form(
          child: TextFormField(
            controller: searchController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: "Search for user ...",
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              filled: true,
              hoverColor: Color(0XFFDADADA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
            },
          ),
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
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

                final docs = data.docs;
                // ignore: unnecessary_type_check
                if (docs is List) {
                  final listUser =
                      docs.map((e) => User.fromSnap(e)).toList();
                  return ListView.builder(
                    itemCount: listUser.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen1(
                              uid: listUser[index].uid,
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              listUser[index]!.photoUrl,
                            ),
                            radius: 16,
                          ),
                          title: Text(
                            listUser[index].username ,
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  // Xử lý khi dữ liệu không phải là danh sách
                  return const Center(
                    child: Text('Invalid data format'),
                  );
                }
              },
            )
          : 
          Container()
          
          //  FutureBuilder(
          //     future: FirebaseFirestore.instance
          //         .collection('posts')
          //         .orderBy('datePublished')
          //         .get(),
          //     builder: (context, snapshot) {
          //       if (!snapshot.hasData || snapshot.data == null) {
          //         return const Center(
          //           child: CircularProgressIndicator(),
          //         );
          //       }

          //       final data = snapshot.data;
          //       if (data == null) {
          //         // Xử lý khi dữ liệu là null
          //         return const Center(
          //           child: Text('No data found'),
          //         );
          //       }
                

          //       return 
                
          //       MasonryGridView.count(
          //         crossAxisCount: 3,
          //         itemCount: data.docs.length,
          //         itemBuilder: (context, index) => Image.network(
          //           data.docs[index]['postUrl'],
          //           fit: BoxFit.cover,
          //         ),
          //         mainAxisSpacing: 8.0,
          //         crossAxisSpacing: 8.0,
          //       );
          //     },
          //   ),
    );
  }
}
