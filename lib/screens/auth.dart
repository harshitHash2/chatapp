import 'package:chatapp/widgets/user_image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:fancy_containers/fancy_containers.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'dart:async';

final _firebase = FirebaseAuth.instance;
// final _fire

class AuthScreen extends StatefulWidget {
  AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  //authentication variables
  // bool _isloading = false;
  var _islogin = true;
  var _form = GlobalKey<FormState>();
  String _enteredemail = "";
  String _enteredpassword = "";
  File? _selectedimage;
  String _enteredusername = "";
  String _enteredname = "";
  List<String> allUsers = [];

  Future<void> _submit() async {
    //validation for form fields
    final _isvalid = _form.currentState!.validate();
    if (!_isvalid || !_islogin && _selectedimage == null) {
      return;
    }
    _form.currentState!.save();

    //Authentication either login or signup
    try {
      if (_islogin) {
        // Log in Authentication
        await _firebase.signInWithEmailAndPassword(
            email: _enteredemail, password: _enteredpassword);
      } else {
        // Sign up with email and password
        var usercredentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _enteredemail, password: _enteredpassword);

        // Using Firebase_storage to save uploaded image and fetching url
        var storageRef = FirebaseStorage.instance
            .ref()
            .child("user_images")
            .child("${usercredentials.user!.uid}.jpg");
        await storageRef.putFile(_selectedimage!);
        final imgUrl = await storageRef.getDownloadURL();

        // Saving credential in firestore database
        await FirebaseFirestore.instance
            .collection('users')
            .doc(usercredentials.user!.uid)
            .set({
          'username': _enteredusername,
          'email': _enteredemail,
          'imageURL': imgUrl,
          'name': _enteredname,
          'uid': FirebaseAuth.instance.currentUser!.uid,
        });

        // Saving username with uid generated by firebase authentication  for searching the users
        await FirebaseFirestore.instance
            .collection('search')
            .doc("username")
            .set({
          _enteredusername: FirebaseAuth.instance.currentUser!.uid,
        }, SetOptions(merge: true));
      }
    } catch (error) {
      //showing snackbar on error
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // _searching_in_db();
  }

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
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                child: Image.asset("assets/images/my_logo.png"),
              ),
              SizedBox(
                height: 20,
              ),
              FancyContainer(
                titleStyle: GoogleFonts.ubuntuMono(),
                width: 300,
                title: 'Fi~Grad',
                color1: Colors.lightGreenAccent,
                color2: Color.fromARGB(255, 163, 227, 255),
                subtitle: 'Welcome to Fi~Grad',
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Card(
                  margin: EdgeInsets.all(5),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Form(
                      key: _form,
                      child: Column(
                        children: [
                          if (!_islogin)
                            UserImagePicker(
                              setimage: (value) {
                                _selectedimage = value;
                              },
                            ),
                          SizedBox(
                            height: 8,
                          ),
                          if (!_islogin)
                            TextFormField(
                              decoration: InputDecoration(
                                label: Text("Username"),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    value.length < 4) {
                                  return "Enter a valid Username!";
                                }

                                if (allUsers.contains(value)) {
                                  return "Already Exists";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _enteredusername = newValue!;
                              },
                            ),
                          SizedBox(
                            height: 15,
                          ),
                          if (!_islogin)
                            TextFormField(
                              decoration: InputDecoration(
                                label: Text("Full Name"),
                              ),
                              onSaved: (newValue) {
                                _enteredname = newValue!;
                              },
                            ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            onSaved: (newValue) {
                              _enteredemail = newValue!;
                            },
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains("@") ||
                                  !value.contains(".com")) {
                                return "Enter a valid email Address!";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: Text("Email"),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                            autocorrect: false,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              label: Text("Password"),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Enter a valid password!";
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _enteredpassword = newValue!;
                            },
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await _submit();
                            },
                            child: Text(_islogin ? "Log In" : "Sign Up"),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _islogin = !_islogin;
                              });
                            },
                            child: Text(_islogin
                                ? "Create a New Account"
                                : "Already have an Account!"),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
