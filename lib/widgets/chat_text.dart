// import 'package:chatapp/models/chatproto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:intl/intl.dart';

class ChatText extends StatefulWidget {
  ChatText({super.key, required this.ct1});
  String ct1;

  @override
  State<ChatText> createState() => _ChatTextState();
}

class _ChatTextState extends State<ChatText> {
  final lk = FirebaseAuth.instance.currentUser!.uid;
  var _text = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _text.dispose();
  }

  // Sent messafe to firestore
  void sent(String p) async {
    final message = p;
    if (message.trim().isEmpty) {
      return;
    }

   
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection("users").doc(lk).get();
      final userData = userDoc.data();

      if (userData != null) {
        print(userData["username"]);
        await FirebaseFirestore.instance
            .collection("messaging")
            .doc(widget.ct1)
            .collection("with")
            .add({
          "text": message,
          "createdAt": DateFormat("hh:mm a").format(DateTime.now()),
          "userId": lk,
          "username": userData["username"],
          "imageURL": userData["imageURL"],
          "isRead": false,
          "date": DateTime.now(),
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something Went Wrong"),
        ),
      );
    }

    
  }

  @override
  Widget build(BuildContext context) {
    return MessageBar(
      onSend: (v) => sent(v),

     
    );

  }
}
