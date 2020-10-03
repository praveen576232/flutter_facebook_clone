import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook/Poast.dart';
import 'package:facebook/Status.dart';
import 'package:facebook/time_ago.dart';
import 'package:facebook/topbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {
  Function scrollOffset;

  Home({this.scrollOffset});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController scrollController;
  ScrollController statusScrollController;
  StreamSubscription<QuerySnapshot> _streamSubscription;
  CollectionReference collectionReference =
      Firestore.instance.collection('poasts');
  CollectionReference status = Firestore.instance.collection('status');
  List<DocumentSnapshot> document;
  List<DocumentSnapshot> statusDocs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
    statusScrollController = ScrollController();
    scrollController.addListener(() {
      widget.scrollOffset(scrollController.offset);
    });
    _streamSubscription = collectionReference
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((doc) {
      if (doc != null) {
        setState(() {
          document = doc.documents;
        });
      }
    });
    status.snapshots().listen((doc) {
      if (doc != null) {
        setState(() {
          statusDocs = doc.documents;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
    _streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Container(
          child: document != null
              ? ListView.builder(
                  controller: scrollController,
                  itemCount: document?.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(children: [
                        Container(
                          color: Colors.white,
                          width: size.width,
                          child: Topbar(),
                        ),
                        statusDocs != null && statusDocs.length > 0
                            ? Container(
                                height: size.height * 0.3,
                                color: Colors.white,
                                child: ListView.builder(
                                  controller: statusScrollController,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: statusDocs?.length,
                                  itemBuilder: (context, index) {
                                    return Status(
                                      status:
                                          statusDocs[index].data['statusUrl'],
                                      userName:
                                          statusDocs[index].data['userName'],
                                      userUrl:
                                          statusDocs[index].data['profileUrl'],
                                    );
                                  },
                                ),
                              )
                            : Offstage(),
                        Poast(
                            timestamp:
                                formatetime(document[0].data['timestamp']),
                            userName: document[0].data['userName'],
                            userUrl: document[0].data['profileUrl'],
                            message: document[0].data['message'],
                            poastUrl: document[0].data['imageUrl'],
                            like: document[index].data['like'],
                            id: document[0].documentID)
                      ]);
                    } else {
                      return Container(
                          child: Poast(
                              timestamp: formatetime(
                                  document[index].data['timestamp']),
                              userName: document[index].data['userName'],
                              userUrl: document[index].data['profileUrl'],
                              message: document[index].data['message'],
                              poastUrl: document[index].data['imageUrl'],
                              like: document[index].data['like'],
                              id: document[index].documentID));
                    }
                  })
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }
}
