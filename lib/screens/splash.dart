import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:fancy_containers/fancy_containers.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

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
        child: FancyContainer(
          titleStyle: GoogleFonts.ubuntuMono(),
          width: 300,
          title: 'Something Went Wrong!',
          color1: Colors.lightGreenAccent,
          color2: Color.fromARGB(255, 163, 227, 255),
          subtitle: 'Fi~Grad',
        ),
      ),
    );
  }
}
