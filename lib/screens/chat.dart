import 'package:chatapp/widgets/chat_por.dart';
import 'package:chatapp/widgets/chat_text.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import '../models/chatproto.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key, required this.unique_id, required this.person});
  String unique_id;
  ChatPeople person;

  // void testing(BuildContext context) async {
  @override
  Widget build(BuildContext context) {
    return ScaffoldGradientBackground(
      gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          Color(0xFF8EC5FC),
          Color.fromARGB(255, 255, 217, 121),
        ],
      ),
      appBar: AppBar(
        // elevation: 50,
        leading: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(person.url),
            )
          ],
        ),
        title: Row(
          children: [
            // CircleAvatar(
            //   backgroundImage: NetworkImage(person.url),
            // ),
            Text(
              person.Name,
              style: GoogleFonts.ubuntu(
                textStyle: Theme.of(context).textTheme.displayLarge,
                fontSize: 30,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
              ),
            )
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 245, 137, 125),
                Color.fromARGB(255, 255, 217, 121),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: ChatPor(
            cp1: unique_id,
            cp2: person,
          )),
          ChatText(
            ct1: unique_id,
          ),
        ],
      ),
    );
  }
}
