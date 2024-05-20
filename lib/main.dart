// import 'dart:js';
// import 'package:riverpod/riverpod.dart';
// import 'package:riverpod/riverpod.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chatapp/models/chatproto.dart';
// import 'package:chatapp/screens/allchats.dart';
import 'package:chatapp/screens/mainscreen.dart';
import 'package:chatapp/screens/profile.dart';
import 'package:chatapp/screens/splash.dart';
import 'package:flutter/material.dart';
import './screens/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './theme/maintheme.dart';
import 'package:flutter/services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  //Firebase initialisation for cli
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  ChatPeople? vj;

 
  Widget content1 = PersonProfile(selfuser: "abc");

  
  @override
  Widget build(BuildContext context) {
    Widget content = StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }

          if (snapshot.hasData) {
            

            return MyScreen();
            
          }
          return AuthScreen();
        });

    return MaterialApp(
      title: 'Fi Grad',
      theme: AppTheme.lightTheme(context),
      home: content,
    );
  }
}
