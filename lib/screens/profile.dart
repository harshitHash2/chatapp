import 'package:chatapp/models/chatproto.dart';
import 'package:chatapp/screens/chat.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import './search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonProfile extends StatefulWidget {
  PersonProfile({super.key, required this.selfuser});
  String selfuser;

  @override
  State<PersonProfile> createState() => _PersonProfileState();
}

class _PersonProfileState extends State<PersonProfile> {
  ChatPeople polo = ChatPeople(
      username: "username",
      Name: "Name",
      url: "url",
      uid: "uid",
      msg_id: "msg_id");
  bool _isloading = false;
  String? selfuid;
  String? p2;
  bool _isFriend = false;
  String? id_sms;

  // Method to remove friend
  // void removefrnd() async {
  //   try {
  //     print(selfuid);
  //     print(id_sms);
  //     await FirebaseFirestore.instance
  //         .collection("friend")
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .collection("with")
  //         .doc(selfuid)
  //         .delete();

  //     await FirebaseFirestore.instance
  //         .collection("friend")
  //         .doc(selfuid)
  //         .collection("with")
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .delete();
  //     await FirebaseFirestore.instance
  //         .collection("messaging")
  //         .doc(id_sms)
  //         .delete()
  //         .then((value) {
  //       setState(() {
  //         _isFriend = false;
  //         print(
  //             "JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ");
  //       });
  //     });
  //     print("DDDDDDDDDDDDDDDDDEEEEEEEEEEEEEEEEELLLLLLLLLLLLLLLLLLLLLLLLLLLLL");
  //   } catch (e) {
  //     print("Errrrrrrrrrrrrrrrrrrrrrrrorrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
  //   }
  //   // setState(() {
  //   //   _isloading = false;
  //   // });
  // }

  // Method to fetch unique message id for chat screen
  void _messageportal() async {
    FirebaseFirestore.instance
        .collection("friend")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("with")
        .doc(selfuid)
        .collection("to")
        .get()
        .then((QuerySnapshot temp1) async {
      // Extracting the unique_msg id for searched person if already friend for chat screen
      id_sms = temp1.docs.first.id;
      polo.msg_id = id_sms!;
      print("This is first ${id_sms}");
    });
  }

  // Method to fetch profile details of the searched person
  void _profiledetails() async {
    setState(() {
      _isloading = true;
    });
    try {
      DocumentSnapshot<Map<String, dynamic>> temp1 =
          await db.collection("search").doc("username").get();

      selfuid = temp1.data()![widget.selfuser];
      print(selfuid);

      temp1 = await db.collection("users").doc(selfuid).get();

      p2 = temp1.data()!["email"];

      polo.Name = temp1.data()!["name"];
      polo.url = temp1.data()!["imageURL"];
      polo.uid = selfuid!;
      polo.username = widget.selfuser;

      String tt = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot<Map<String, dynamic>> cond = await db
          .collection("friend")
          .doc(tt)
          .collection("with")
          .doc(selfuid)
          .get();

      if (cond.data() != null) {
        setState(() {
          _isFriend = true;
        });
        if (_isFriend) {
          _messageportal();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
    setState(() {
      _isloading = false;
    });
  }

  // Method to add friend to user
  void addfriend() async {
    String f1 = FirebaseAuth.instance.currentUser!.uid;

    //checking if already friend
    if (_isFriend) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Already a friend"),
        ),
      );
      return;
    }

    // If not settinging the friendship
    try {
      await FirebaseFirestore.instance
          .collection("friend")
          .doc(f1)
          .collection("with")
          .doc(selfuid)
          .collection("to")
          .add({
        "friendship": "true",
      });
    } catch (error) {
      // Handle any errors that occur during the asynchronous operations
      print("Error fetching data: $error");
    }

    // fetching unique message id
    try {
      FirebaseFirestore.instance
          .collection("friend")
          .doc(f1)
          .collection("with")
          .doc(selfuid)
          .collection("to")
          .get()
          .then((QuerySnapshot temp1) async {
        // Executing statements after fetching QuerySnapshot

        // Extracting the unique_msg
        id_sms = temp1.docs.first.id;
        polo.msg_id = id_sms!;

        // Setting the searched person friendship with current user to show friends in both the user with same message key
        await FirebaseFirestore.instance
            .collection("friend")
            .doc(selfuid)
            .collection("with")
            .doc(f1)
            .collection("to")
            .doc(id_sms)
            .set({
          "friendship": "true",
        });

        // Setting the unique message id shared with both the person  for chat screen
        await FirebaseFirestore.instance
            .collection("messaging")
            .doc(id_sms)
            .collection("with")
            .add({
          "text": "",
          "createdAt": "--",
          "userId": "lk",
          "username": "userData[]",
          "imageURL": "userData[]",
          "isRead": true,
          "date": DateTime.now()
        });
      });

      // For Searching of the users with friend we set the document with friendship key value pairs again in both users
      await FirebaseFirestore.instance
          .collection("friend")
          .doc(selfuid)
          .collection("with")
          .doc(f1)
          .set({
        "friendship": "true",
      });

      await FirebaseFirestore.instance
          .collection("friend")
          .doc(f1)
          .collection("with")
          .doc(selfuid)
          .set({
        "friendship": "true",
      });
    } catch (error) {
      // Handle any errors that occur during the asynchronous operations
      print("Error fetching data: $error");
    }

    setState(() {
      _isFriend = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _profiledetails();
  }

  @override
  Widget build(BuildContext context) {
    if (_isloading) {
      return Center(
        child: LoadingIndicator(
            indicatorType: Indicator.ballScaleMultiple,
            colors: const [Color.fromARGB(255, 224, 179, 54)],
            strokeWidth: 2,
            // backgroundColor: Colors.black,
            pathBackgroundColor: Colors.black),
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
        title: Text(
          widget.selfuser,
          style: GoogleFonts.ubuntu(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontSize: 30,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
          ),
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
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(polo.url),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                child: Text(
                  polo.Name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Text(p2!),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                        onPressed: addfriend,
                        label: _isFriend ? Text("Friends") : Text("Add Friend"),
                        icon: _isFriend
                            ? Icon(MdiIcons.accountCheck)
                            : Icon(MdiIcons.accountMultiplePlus)),
                    SizedBox(
                      width: 15,
                    ),
                    TextButton.icon(
                        label: Text("Message"),
                        onPressed: _isFriend
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                          unique_id: polo.msg_id,
                                          person: polo)),
                                );
                              }
                            : null,
                        icon: _isFriend
                            ? Icon(MdiIcons.message)
                            : Icon(MdiIcons.messageLock)),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
