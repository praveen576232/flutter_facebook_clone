import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook/Comments.dart';
import 'package:facebook/Firebase/firestore.dart';
import 'package:facebook/my_custome_icons_icons.dart';
import 'package:flutter/material.dart';

class Poast extends StatefulWidget {
  String userUrl;
  String userName;
  String timestamp;
  String message;
  String poastUrl;
  List like;
  String id;

  Poast(
      {@required this.userUrl,
      this.message,
      this.poastUrl,
      @required this.timestamp,
      @required this.userName,
      @required this.like,
      @required this.id});

  @override
  _PoastState createState() => _PoastState();
}

class _PoastState extends State<Poast> {
  bool checkuserLikestoPoast = false;
  StreamSubscription commentSubscription;
  Query _query;
  List<DocumentSnapshot> snapshot;
  Firestore _firestore = Firestore.instance;
  @override
  void initState() {
    // TODO: implement initState

    checkuserLikestoPoast = checkUserLikeToThisPoast(widget.like);
    _query = _firestore
        .collection('poasts')
        .document(widget.id)
        .collection('comments')
        .orderBy('timestamp', descending: true);
    commentSubscription = _query.snapshots().listen((docs) {
      setState(() {
        snapshot = docs.documents;
      });
    });
    super.initState();
  }

  showComments(Size size) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Comments(comments: snapshot, size: size, id: widget.id);
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    commentSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 0.0, right: 0.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: widget.userUrl != null &&
                                  widget.userUrl != '' &&
                                  widget.userUrl.contains('https://')
                              ? NetworkImage(widget.userUrl)
                              : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.userName != null ? widget.userName : '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                              ),
                              Text(
                                widget.timestamp != null
                                    ? widget.timestamp
                                    : '',
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.more_horiz, color: Colors.grey[700]),
                      onPressed: () {})
                ],
              ),
            ),
            widget.message != null
                ? Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(widget.message),
                      ),
                    ),
                  )
                : Offstage(),
            widget.poastUrl != null &&
                    widget.poastUrl != '' &&
                    widget.poastUrl.contains('https://')
                ? Container(
                    child: Image.network(
                    widget.poastUrl,
                    fit: BoxFit.fill,
                  ))
                : Offstage(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.like != null ? widget.like?.length : 0} likes',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    '${snapshot != null ? snapshot?.length : 0} comments',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            Container(height: 1, color: Colors.grey[300]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                    onPressed: () {
                      addLikesToPoast(widget.like, widget.id);
                      setState(() {
                        checkuserLikestoPoast = !checkuserLikestoPoast;
                      });
                    },
                    child: Icon(Icons.thumb_up,
                        color: checkuserLikestoPoast
                            ? Colors.blueAccent
                            : Colors.grey[300])),
                FlatButton(
                    onPressed: () {
                      showComments(size);
                    },
                    child:
                        Icon(MyCustomeIcons.comment, color: Colors.grey[300])),
                FlatButton(
                    onPressed: () {},
                    child: Icon(MyCustomeIcons.share, color: Colors.grey[300])),
              ],
            ),
            Container(height: 1, color: Colors.grey[300])
          ],
        ),
      ),
    );
  }
}
