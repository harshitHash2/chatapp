import 'package:chatapp/screens/temp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import '../models/chatproto.dart';
import '../screens/search.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../screens/allchats.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:fancy_containers/fancy_containers.dart';

class MyScreen extends StatefulWidget {
  MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

  bool _isloading = false;
  ChatPeople vj = ChatPeople(
      username: "username",
      Name: "Name",
      url: "url",
      uid: "uid",
      msg_id: "msg_id");
  Set<String> _allusers = {};

  //
  Future<void> fetch_message() async {
    // Fetching all friends of the user
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
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  @override
  void initState() {
    super.initState();
    fetch_message();
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

    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueGrey, Colors.blueGrey.withOpacity(0.2)],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: true,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: ScaffoldGradientBackground(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xFF8EC5FC),
            Color.fromARGB(255, 255, 217, 121),
          ],
        ),
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Search_bar()),
                  );
                },
                icon: Icon(MdiIcons.magnify)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllChats()),
                  );
                },
                icon: Icon(MdiIcons.chat)),
          ],
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
            "Fi~Grad",
            style: GoogleFonts.ubuntu(
              textStyle: Theme.of(context).textTheme.displayLarge,
              fontSize: 30,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
          ),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
        ),
        body: Center(
          child: FancyContainer(
            titleStyle: GoogleFonts.ubuntuMono(),
            width: 300,
            title: 'Fi~Grad',
            color1: Colors.lightGreenAccent,
            color2: Color.fromARGB(255, 163, 227, 255),
            subtitle: 'Welcome to Fi~Grad',
          ),
        ),
      ),
      drawer: SafeArea(
        child: Container(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 64.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset("assets/images/my_logo.png"),
                ),
                ListTile(
                  onTap: () {
                    _advancedDrawerController.hideDrawer();
                  },
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Mypage()),
                    );
                  },
                  leading: Icon(Icons.account_circle_rounded),
                  title: Text('Profile'),
                ),
                ListTile(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                  leading: Icon(MdiIcons.logout),
                  title: Text('Log-out'),
                ),
                Spacer(),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: Text('© 2024 Uttar Pradesh, India | Privacy Policy'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
