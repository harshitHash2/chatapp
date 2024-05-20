// import 'dart:ffi';

import 'package:chatapp/screens/chat.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chatproto.dart';

class AllchatTiles extends StatefulWidget {
  AllchatTiles({super.key, required this.polo});
  Set<ChatPeople> polo;

  @override
  State<AllchatTiles> createState() => _AllchatTilesState();
}

class _AllchatTilesState extends State<AllchatTiles> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.polo.length,
        itemBuilder: ((context, index) {
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(
                          unique_id: widget.polo.elementAt(index).msg_id,
                          person: widget.polo.elementAt(index))),
                );
              },
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.polo.elementAt(index).url),
              ),
              title: Text(widget.polo.elementAt(index).Name),
              subtitle: Text(widget.polo.elementAt(index).username),
              trailing: Text("time"),
            ),
          );
        }));
  }
}
