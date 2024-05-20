// import 'package:flutter/material.dart';
import 'package:chatapp/models/msgproto.dart';
import 'package:chatapp/screens/chat.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chatproto.dart';

import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

import 'package:fancy_containers/fancy_containers.dart';

class Temp2 extends StatefulWidget {
  Temp2({super.key, required this.vj, required this.cj});
  Set<ChatPeople> vj;
  Set<String> cj;

  @override
  State<Temp2> createState() => _Temp2State();
}

class _Temp2State extends State<Temp2> {
  List<MsgPro> _finalmsgs = [];
  bool _isloading = false;

  Future<void> msgsearch() async {
    int count = 0;
    for (ChatPeople i in widget.vj) {
      await FirebaseFirestore.instance
          .collection("messaging")
          .doc(i.msg_id)
          .collection("with")
          .orderBy("date", descending: true)
          .limit(1) // Limiting to only one document
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          // Accessing data of the first document
          var data = doc.data()! as Map<String, dynamic>;

          if (data["messaging"] == "created") {
            _finalmsgs.add(MsgPro(
                text: "Tap to Chat", isRead: false, time: "--", uid: "nil"));
          }

          if ((count) < _finalmsgs.length) {
            _finalmsgs[count] = MsgPro(
                text: data["text"],
                isRead: data["isRead"],
                time: data["createdAt"],
                uid: data["userId"]);
          } else {
            _finalmsgs.add(MsgPro(
                text: data["text"],
                isRead: data["isRead"],
                time: data["createdAt"],
                uid: data["userId"]));
          }
          print(data["createdAt"]);

          count++;

          setState(() {
            _isloading = false;
          });
        });
      }).catchError((error) {
        print("Failed to fetch document: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("messaging")
            .where(FieldPath.documentId, whereIn: widget.cj)
            .snapshots(),
        builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          msgsearch();

          if (_finalmsgs.length != widget.vj.length) {
            return ScaffoldGradientBackground(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xFF8EC5FC),
                  Color.fromARGB(255, 255, 217, 121),
                ],
              ),
              body: Center(
                child: FancyContainer(
                  titleStyle: GoogleFonts.ubuntuMono(),
                  width: 300,
                  title: 'Please Wait...',
                  color1: Colors.lightGreenAccent,
                  color2: Color.fromARGB(255, 163, 227, 255),
                  subtitle: 'Fi~Grad',
                ),
              ),
            );
          }

          return ListView.builder(
              itemCount: widget.vj.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(
                              unique_id: widget.vj.elementAt(index).msg_id,
                              person: widget.vj.elementAt(index))),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(widget.vj.elementAt(index).url),
                  ),
                  title: (_finalmsgs.length != widget.vj.length)
                      ? Text(widget.vj.elementAt(index).Name)
                      : Text(
                          widget.vj.elementAt(index).Name,
                          style: _finalmsgs.elementAt(index).isRead ||
                                  _finalmsgs.elementAt(index).uid ==
                                      FirebaseAuth.instance.currentUser!.uid
                              ? TextStyle(fontWeight: FontWeight.normal)
                              : TextStyle(fontWeight: FontWeight.w900),
                        ),
                  subtitle: (_finalmsgs.length != widget.vj.length)
                      ? Text("Tap to Chat")
                      : Text(
                          _finalmsgs.elementAt(index).text,
                          style: _finalmsgs.elementAt(index).isRead ||
                                  _finalmsgs.elementAt(index).uid ==
                                      FirebaseAuth.instance.currentUser!.uid
                              ? TextStyle(fontWeight: FontWeight.normal)
                              : TextStyle(fontWeight: FontWeight.w900),
                        ),
                  trailing: (_finalmsgs.length != widget.vj.length)
                      ? Text("")
                      : Text(
                          _finalmsgs.elementAt(index).time,
                          style: _finalmsgs.elementAt(index).isRead ||
                                  _finalmsgs.elementAt(index).uid ==
                                      FirebaseAuth.instance.currentUser!.uid
                              ? TextStyle(fontWeight: FontWeight.normal)
                              : TextStyle(fontWeight: FontWeight.w900),
                        ),
                );
              }));
        });
  }
}
