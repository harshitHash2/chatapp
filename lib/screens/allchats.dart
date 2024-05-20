import 'package:chatapp/models/msgproto.dart';
import 'package:chatapp/widgets/allchattile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chatproto.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:fancy_containers/fancy_containers.dart';



class AllChats extends StatefulWidget {
  AllChats({super.key});

  @override
  State<AllChats> createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  Set<MsgPro> _finalmsgs = {};
  Set<String> _allusers = {};
  Set<ChatPeople> _finalpeople = {};
  String unique_msg = "";
  bool isloading = false;
  Set<String> _msgset = {};


  // Method to fetch recent message of all the user to show in all chats
  Future<void> msgsearch(String s) async {
    await FirebaseFirestore.instance
        .collection("messaging")
        .doc(s)
        .collection("with")
        .orderBy("createdAt", descending: true)
        .limit(1) // Limiting to only one document
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // Accessing data of the first document
        var data = doc.data()! as Map<String, dynamic>;
        _finalmsgs.add(MsgPro(
            text: data["text"],
            isRead: data["isRead"],
            time: data["createdAt"],
            uid: data["userId"]));
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    });
  }

  //Method to search all friends of the user and fetching profile details
  void searchchats() async {
    _finalpeople = {};
    unique_msg = "";
    setState(() {
      isloading = true;
    });

    // Getting all friends
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("friend")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("with")
          .get();

      querySnapshot.docs.forEach((doc) {
        _allusers.add(doc.id);
        print(_allusers);
      });
    } catch (error) {
      // Handle any errors that occur during the asynchronous operations
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something Went Wrong"),
        ),
      );
    }

    // Fetching the unique message key of all friends of the user 
    try {
      for (String item in _allusers) {
        FirebaseFirestore.instance
            .collection("friend")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("with")
            .doc(item)
            .collection("to")
            .get()
            .then((QuerySnapshot temp1) async {
          // Executing statements after fetching QuerySnapshot

          // Extracting the unique_msg
          String unique_msg = temp1.docs.first.id;
          // msgsearch(unique_msg);

          _msgset.add(temp1.docs.first.id);

          final docRef =
              await FirebaseFirestore.instance.collection("users").doc(item);
          docRef.get().then((DocumentSnapshot doc) {
            final data1 = doc.data() as Map<String, dynamic>;

            setState(() {
              _finalpeople.add(ChatPeople(
                username: data1["username"],
                Name: data1["name"],
                url: data1["imageURL"],
                uid: data1["uid"],
                msg_id: unique_msg,
              ));
            });
          
          });
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
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    searchchats();
  }

  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return Center(
        child: LoadingIndicator(
            indicatorType: Indicator.ballScaleMultiple,
            colors: const [Color.fromARGB(255, 224, 179, 54)],
            strokeWidth: 2,
            // backgroundColor: Colors.black,
            pathBackgroundColor: Colors.black),
      );
    }

    if (_allusers.isEmpty) {
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
            title: 'No One! to talk, Search to Add Friends',
            color1: Colors.lightGreenAccent,
            color2: Color.fromARGB(255, 163, 227, 255),
            subtitle: 'Fi~Grad',
          ),
        ),
      );
    } else if (_finalpeople.isEmpty) {
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
        title: Text(
          "Chit ~ Chat",
          style: GoogleFonts.ubuntu(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontSize: 30,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: Temp2(vj: _finalpeople, cj: _msgset),
    );
  }
}
