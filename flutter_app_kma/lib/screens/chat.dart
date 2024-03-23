import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/user.dart' as models;
import 'package:flutter_app/resources/auth_methods.dart';
import 'package:flutter_app/resources/chat_methods.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;
  ChatPage({
    Key? key,
    required this.receiverEmail,
    required this.receiverID,
  }) : super(key: key);

  final TextEditingController _messageController = TextEditingController();

  // chat service
  final ChatService _chatService = ChatService();
  final AuthMethods _authMethods = AuthMethods();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(receiverID, _messageController.text);
      _messageController.clear();
    }
  }

  String? getCurrentUID() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
  String? senderID = getCurrentUID();
  return StreamBuilder<QuerySnapshot>(
    stream: _chatService.getMessages(senderID!, receiverID),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text("Error");
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Text("Loading...");
      }
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: ListView(
          children: snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            bool isSentByCurrentUser = data['senderId'] == senderID;
      
            return Align(
              alignment: isSentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: isSentByCurrentUser ? Colors.blue : Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  data['message'].toString(),
                  style: TextStyle(
                    fontSize: 20,
                    color: isSentByCurrentUser ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    },
  );
}



  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(Icons.send),
        ),
      ],
    );
  }
}
