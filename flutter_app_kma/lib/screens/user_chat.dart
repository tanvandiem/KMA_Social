import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/chat.dart';


class UserChat extends StatefulWidget {
  const UserChat({super.key});

  @override
  State<UserChat> createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
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
        title: Text("Chat"),
      ),
      body: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'uid', 
                    isNotEqualTo: getCurrentUID()
                   
                  )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot snap =
                            (snapshot.data as dynamic).docs[index];
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            receiverEmail: (snapshot.data! as dynamic).docs[index]['email'],
                            receiverID: (snapshot.data! as dynamic).docs[index]['uid'],
                            
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            snap['photoUrl'],
                          ),
                          radius: 16,
                        ),
                        title: Text(
                          (snapshot.data as dynamic).docs[index]['username'],
                        ),
                      ),
                    );
                  },
                );
              },
            )
    );
  }
}
