import 'package:chatapp/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import '../models/searchmodel.dart';
import 'package:loading_indicator/loading_indicator.dart';

final db = FirebaseFirestore.instance;

class Search_bar extends StatefulWidget {
  const Search_bar({super.key});

  @override
  State<Search_bar> createState() => _Search_barState();
}

class _Search_barState extends State<Search_bar> {
  var _text1 = TextEditingController();
  bool _isloading = false;
  Set<SearchModel> _searchresults = {};
  Set<SearchModel> hyp = {};

  // Method to search username of all users and fetching profile picture to show people in search
  void searching_in_db() async {
    setState(() {
      _isloading = true;
    });

    //
    final docRef = db.collection("users");
    docRef.snapshots().listen(
      (event) {
        var k = event.docs;
        for (QueryDocumentSnapshot kj in k) {
          Map<String, dynamic> jp = kj.data()! as Map<String, dynamic>;
          if (jp["uid"] != FirebaseAuth.instance.currentUser!.uid) {
            setState(() {
              hyp.add(SearchModel(
                  imageURL: jp["imageURL"], username: jp["username"]));
            });
          }
        }
      },
      onError: (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
      },
    );
    setState(() {
      _isloading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _text1.dispose();
  }

  @override
  void initState() {
    super.initState();
    searching_in_db();
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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(28)), // Adjust the radius as needed
                      ),
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                          controller: _text1,
                          onChanged: (value) {
                            if (value.length == 0) {
                              setState(() {
                                _searchresults = {};
                              });
                              return;
                            }
                            _searchresults = {};
                            for (SearchModel item in hyp) {
                              print(item.username);
                              // Check if the item contains the specified letter
                              if (item.username
                                  .toLowerCase()
                                  .contains(value.toLowerCase())) {
                                // Add the item to the search results list
                                if (!_searchresults.contains(item)) {
                                  setState(() {
                                    _searchresults.add(item);
                                  });
                                  print(item.username);
                                }
                              }
                            }
                            print(_searchresults.length);
                          },
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            border: InputBorder.none,
                            labelText: "Search...",
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: searching_in_db, icon: Icon(Icons.search)),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (_searchresults.length == 0)
              Container(
                child: Center(
                  child: Text("No Result"),
                ),
              ),
            if (_searchresults.length > 0)
              Expanded(
                child: ListView.builder(
                    itemCount: _searchresults.length,
                    itemBuilder: (ctx, index) {
                      //retrieving userdata

                      String v = _searchresults.elementAt(index).username;
                      String p = _searchresults.elementAt(index).imageURL;

                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PersonProfile(selfuser: v)),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(p),
                        ),
                        title: Text(
                          v,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }),
              ),
          ],
        ),
      ),
    );
  }
}
