import 'package:chatapp/models/chatproto.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_bubbles/chat_bubbles.dart';


class ChatPor extends StatefulWidget {
  ChatPor({Key? key, required this.cp1, required this.cp2}) : super(key: key);
  final String cp1;
  final ChatPeople cp2;

  @override
  State<ChatPor> createState() => _ChatPorState();
}

class _ChatPorState extends State<ChatPor> {
  @override
  void initState() {
    super.initState();
    // Call a function to fetch messages and mark them as read
    fetchAndMarkMessagesAsRead();
  }

  // Making isRead flag to true on each message visit
  Future<void> markMessageAsRead(DocumentSnapshot message) async {
    print(message.id);
    if (message['isRead'] == false &&
        message["userId"] != FirebaseAuth.instance.currentUser!.uid) {
      await FirebaseFirestore.instance
          .collection('messaging')
          .doc(widget.cp1)
          .collection("with")
          .doc(message.id)
          .update({'isRead': true});
    }
  }

  // Initialise of Read Flag to true
  Future<void> fetchAndMarkMessagesAsRead() async {
    try {
      final messagesSnapshot = await FirebaseFirestore.instance
          .collection("messaging")
          .doc(widget.cp1)
          .collection("with")
          .orderBy("createdAt", descending: true)
          .get();

      for (final message in messagesSnapshot.docs) {
        await markMessageAsRead(message);
      }
    } catch (error) {
      // Handle errors
      print("Error fetching messages: $error");
    }
  }

  // Using Stream Builder to fetch message as stream on changes in firestore
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("messaging")
          .doc(widget.cp1)
          .collection("with")
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text("No messages");
        }

        final loadedmessage = snapshot.data!.docs;

        return ListView.builder(
          padding: EdgeInsets.all(15),
          reverse: true,
          itemCount: loadedmessage.length,
          itemBuilder: (ctx, index) {
            final m = loadedmessage[index].data()! as Map<String, dynamic>;

            // Check if the message is read by the current user
            final bool isReadByCurrentUser = m["isRead"] &&
                m["userId"] == FirebaseAuth.instance.currentUser!.uid;

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      BubbleSpecialOne(
                        seen: isReadByCurrentUser,
                        text: m["text"],
                        isSender: m["userId"] ==
                            FirebaseAuth.instance.currentUser!.uid,
                        color: Color(0xFF1B97F3),
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
