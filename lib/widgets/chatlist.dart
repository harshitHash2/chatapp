import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import '../models/chatproto.dart';
import '../screens/chat.dart';

class ChatList extends StatefulWidget {
  ChatList({super.key, required this.jj});
  List<String> jj;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  Set<ChatPeople> _finalpeople = {};
  String unique_msg = "";
  String gl = FirebaseAuth.instance.currentUser!.uid;
  void searchchats() async {

    for (String item in widget.jj) {
      QuerySnapshot temp1 = await FirebaseFirestore.instance
          .collection("friend")
          .doc(gl)
          .collection("with")
          .doc(item)
          .collection("to")
          .get();
      unique_msg = temp1.docs.first.id;

      final docRef = FirebaseFirestore.instance.collection("users").doc(item);
      docRef.get().then(
        (DocumentSnapshot doc) {
          final data1 = doc.data() as Map<String, dynamic>;
          
          _finalpeople.add(ChatPeople(
            username: data1["username"],
            Name: data1["name"],
            url: data1["imageURL"],
            uid: data1["uid"],
            msg_id: unique_msg,
          ));
        },
        onError: (e) => print("Error getting document: $e"),
      );
    }

  }

  @override
  void initState() {
    super.initState();
    searchchats();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _finalpeople.length,
        itemBuilder: ((context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                        unique_id: unique_msg,
                        person: _finalpeople.elementAt(index))),
              );
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(_finalpeople.elementAt(index).url),
            ),
            title: Text(_finalpeople.elementAt(index).Name),
            subtitle: Text("Tap to Chit-Chat"),
            trailing: Text("time"),
          );
        }));
  }
}
