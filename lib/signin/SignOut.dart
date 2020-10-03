import 'package:facebook/signin/GoogleSignIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: Center(
          child: FlatButton(
              color: Colors.blue,
              onPressed: () async {
                FirebaseAuth.instance.signOut().whenComplete(() =>
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => GoogleSignin()),
                        (route) => false));
              },
              child: Text('LogOut ?',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }
}
