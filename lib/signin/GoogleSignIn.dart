import 'package:facebook/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignin extends StatelessWidget {
  Future signin(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      GoogleSignInAccount _googleSignInAccount = await _googleSignIn.signIn();
      if (_googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await _googleSignInAccount.authentication;
        AuthCredential authCredential = GoogleAuthProvider.getCredential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);
        _auth.signInWithCredential(authCredential).then((user) {
          if (user != null) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => FaceBook(user: user.user)));
          } else {
            errorDialog(context);
          }
        });
      }
    } catch (e) {
      errorDialog(context);
    }
  }

  errorDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("somthing wen wrong while login"),
            content: Text('Try Again'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ok'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Facebook_Logo_%282019%29.png/1200px-Facebook_Logo_%282019%29.png',
                  fit: BoxFit.fill,
                  width: 100,
                ),
                SizedBox(height: 10),
                FlatButton(
                  onPressed: () {
                    signin(context);
                  },
                  child: Container(
                    width: 200,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.blueAccent,
                    ),
                    child: Center(
                      child: Text('login with google',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
