import 'package:flutter/material.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chatproto.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Mypage extends StatefulWidget {
  Mypage({super.key});

  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  File? _pickedImageFile;
  bool _isloading = false;
  ChatPeople? vj;

  Future<void> fetchprof() async {
    setState(() {
      _isloading = true;
    });
    // fetching profile of the authenticated user
    try {
      DocumentSnapshot<Map<String, dynamic>> temp1 = await FirebaseFirestore
          .instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      // .then((value) {
      setState(() {
        vj = ChatPeople(
            username: temp1.data()!["username"],
            Name: temp1.data()!["name"],
            url: temp1.data()!["imageURL"],
            uid: FirebaseAuth.instance.currentUser!.uid,
            msg_id: "msg_id");
      });
      // });
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something Went Wrong"),
        ),
      );
    }
    setState(() {
      _isloading = false;
    });
  }

  // Method to change profile picture of the authenticated user
  void _galImage() async {
    var _polo = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (_polo == null) {
      return;
    }
    setState(() {
      _isloading = true;
      _pickedImageFile = File(_polo.path);
    });

    var storageRef = FirebaseStorage.instance
        .ref()
        .child("user_images")
        .child("${FirebaseAuth.instance.currentUser!.uid}.jpg");
    await storageRef.putFile(_pickedImageFile!);
    final imgUrl = await storageRef.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'imageURL': imgUrl,
    });

    setState(() {
      _isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchprof();
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
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // height: 300,
              // width: 400,
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(vj!.url),
                foregroundImage: _pickedImageFile != null
                    ? FileImage(_pickedImageFile!)
                    : null,
              ),
              SizedBox(
                height: 25,
              ),
              TextButton.icon(
                  onPressed: _galImage,
                  icon: Icon(MdiIcons.cameraPlus),
                  label: Text("Change Photo")),
              SizedBox(
                height: 25,
              ),
              Container(
                child: Text(
                  vj!.Name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(
                height: 15,
              ),
              Container(
                child: Text(vj!.username),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: null,
                      icon: Icon(MdiIcons.accountCheck),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.wrap_text)),
                    SizedBox(
                      width: 15,
                    ),
                    IconButton(
                        onPressed: () {}, icon: Icon(Icons.weekend_sharp)),
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
