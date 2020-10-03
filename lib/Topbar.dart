import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook/Firebase/currentUser.dart';
import 'package:facebook/Status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Topbar extends StatefulWidget {
  Topbar();
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Topbar> {
  bool uplodeFiled = false;
  TextEditingController messageTextController = TextEditingController();
  TextEditingController urlTextController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    messageTextController.dispose();
    urlTextController.dispose();
    super.dispose();
  }

  sendpoast() {
    if (messageTextController.text != null || urlTextController.text != null) {
      if (user != null) {
        Firestore.instance.collection('poasts').add({
          'userName': user?.displayName,
          'profileUrl': user?.photoUrl,
          'timestamp': FieldValue.serverTimestamp(),
          'imageUrl':
              urlTextController.text != null ? urlTextController.text : null,
          'message': messageTextController.text != null
              ? messageTextController.text
              : null
        }).whenComplete(() {
          messageTextController.text = '';
          urlTextController.text = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      user != null ? NetworkImage(user?.photoUrl) : null,
                  backgroundColor: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(color: Colors.grey[300], width: 2)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextField(
                        controller: messageTextController,
                        decoration: InputDecoration(
                            hintText:
                                'Write something ${user != null ? user?.displayName : ''}',
                            border: InputBorder.none),
                        onSubmitted: (text) => sendpoast(),
                      ),
                    ),
                  ),
                ),
                FlatButton(
                    onPressed: () {
                      setState(() {
                        uplodeFiled = !uplodeFiled;
                      });
                    },
                    child: uplodeFiled ? Text('Cancel') : Text('Uplode Image'))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: AnimatedContainer(
              padding: EdgeInsets.only(left: 8.0),
              duration: Duration(microseconds: 800),
              height: uplodeFiled ? 50 : 0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(color: Colors.grey[300], width: 2)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  controller: urlTextController,
                  onSubmitted: (t) => sendpoast(),
                  decoration: InputDecoration(
                      hintText: 'Enter image url here...',
                      border: InputBorder.none),
                ),
              ),
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: FlatButton(
                    shape: Border(
                        right: BorderSide(color: Colors.grey[300], width: 1)),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.video_call,
                          color: Colors.red,
                        ),
                        Text(' Live')
                      ],
                    )),
              ),
              Expanded(
                child: FlatButton(
                    shape: Border(
                        right: BorderSide(color: Colors.grey[300], width: 1)),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.photo_library,
                          color: Colors.greenAccent,
                        ),
                        Text(' Photos')
                      ],
                    )),
              ),
              Expanded(
                child: FlatButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.videocam,
                          color: Colors.purple,
                        ),
                        Text(' Room')
                      ],
                    )),
              ),
            ],
          ),
          Container(
            height: 8,
            color: Colors.grey[300],
          )
        ],
      ),
    );
  }
}
