import 'package:facebook/Firebase/currentUser.dart';
import 'package:facebook/Home.dart';
import 'package:facebook/my_custome_icons_icons.dart';
import 'package:facebook/signin/GoogleSignIn.dart';
import 'package:facebook/signin/SignOut.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(AuthCheck());
}

class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  FirebaseAuth firebaseauth;
  FirebaseUser currentUser;
  GoogleSignIn _googleSignIn;
  @override
  void initState() {
    feacthcurrentUser();

    super.initState();
  }

  feacthcurrentUser() async {
    currentUser = await getCurrentUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return currentUser != null ? FaceBook(user: currentUser) : GoogleSignin();
  }
}

class FaceBook extends StatefulWidget {
  FirebaseUser user;
  FaceBook({@required this.user});
  @override
  _FaceBookState createState() => _FaceBookState();
}

class _FaceBookState extends State<FaceBook>
    with SingleTickerProviderStateMixin {
  TabController controller;
  int index = 0;
  @override
  void initState() {
    // TODO: implement initState
    controller = TabController(length: 6, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  bool scrolling = false;
  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      setState(() {
        index = controller.index;
      });
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(100, 150),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: index == 0 && !scrolling ? 120 : 80.0,
            child: AppBar(
              backgroundColor: Colors.white,
              title: index == 0 && !scrolling
                  ? Image.asset(
                      'assert/facebook.png',
                      height: 85,
                      fit: BoxFit.cover,
                    )
                  : Offstage(),
              actions: [
                index == 0
                    ? CircleAvatar(
                        child: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        backgroundColor: Colors.grey[100],
                      )
                    : Offstage(),
                index == 0
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          child: Icon(
                            MyCustomeIcons.facebook_messenger,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : Offstage()
              ],
              bottom: TabBar(
                  indicatorColor: Colors.blue,
                  controller: controller,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.home,
                          color: index == 0 ? Colors.blue : Colors.black),
                    ),
                    Tab(
                      icon: Icon(Icons.people_outline,
                          color: index == 1 ? Colors.blue : Colors.black),
                    ),
                    Tab(
                      icon: Icon(Icons.ondemand_video,
                          color: index == 2 ? Colors.blue : Colors.black),
                    ),
                    Tab(
                      icon: Icon(Icons.store_mall_directory,
                          color: index == 3 ? Colors.blue : Colors.black),
                    ),
                    Tab(
                      icon: Icon(Icons.notifications_none,
                          color: index == 4 ? Colors.blue : Colors.black),
                    ),
                    Tab(
                      icon: Icon(Icons.menu,
                          color: index == 5 ? Colors.blue : Colors.black),
                    )
                  ]),
            ),
          ),
        ),
        body: TabBarView(controller: controller, children: [
          Home(
            scrollOffset: (offset) {
              if (offset > 70) {
                if (!scrolling) {
                  setState(() {
                    scrolling = true;
                  });
                }
              } else {
                if (scrolling) {
                  setState(() {
                    scrolling = false;
                  });
                }
              }
            },
          ),
          Home(),
          Home(),
          Home(),
          Home(),
          SignOut(),
        ]),
      ),
    );
  }
}
