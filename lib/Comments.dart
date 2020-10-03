import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook/Firebase/currentUser.dart';
import 'package:facebook/my_custome_icons_icons.dart';
import 'package:facebook/time_ago.dart';
import 'package:flutter/material.dart';

class Comments extends StatelessWidget {
  List<DocumentSnapshot> comments;
  Size size;
  String id;
  Comments({@required this.comments, @required this.size, @required this.id});
  sendComment(String comment) {
    if (user != null && comment != null) {
      if (comments != null) {
        textEditingController.text = '';
        Firestore.instance
            .collection('poasts')
            .document(id)
            .collection('comments')
            .add({
          'message': comment,
          'userName': user.displayName,
          'userProfile': user.photoUrl,
          'timestamp': FieldValue.serverTimestamp()
        });
      }
    }
  }

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.95,
      child: SafeArea(
        child: Scaffold(
            body: Stack(
          children: [
            comments != null && comments.length > 0
                ? Container(
                    child: ListView.builder(
                        itemCount: comments?.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      maxRadius: 25.0,
                                      backgroundImage: NetworkImage(comments !=
                                              null
                                          ? comments[index].data['userProfile']
                                          : ''),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  comments != null
                                                      ? comments[index]
                                                          .data['userName']
                                                      : '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17.0),
                                                ),
                                                Text(
                                                  comments != null
                                                      ? comments[index]
                                                          .data['message']
                                                      : '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15.0),
                                                ),
                                                Container(
                                                    child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      comments != null
                                                          ? formatetime(comments[
                                                                              index]
                                                                          .data[
                                                                      'timestamp']) !=
                                                                  null
                                                              ? formatetime(
                                                                  comments[index]
                                                                          .data[
                                                                      'timestamp'])
                                                              : '1 sec ago'
                                                          : '',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12.0),
                                                    ),
                                                    Text(
                                                      '   Like  ',
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 12.0),
                                                    ),
                                                    Text(
                                                      'Replay',
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 12.0),
                                                    )
                                                  ],
                                                ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                : Container(
                    child: Center(
                      child: Text('no comments in this poast'),
                    ),
                  ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: Icon(MyCustomeIcons.camera), onPressed: () {}),
                      Expanded(
                        child: Container(
                          //  width: 100,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextField(
                              controller: textEditingController,
                              autofocus: true,
                              decoration: InputDecoration(
                                  hintText: 'Write a comment...',
                                  border: InputBorder.none),
                              onSubmitted: (text) => sendComment(text),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            IconButton(icon: Icon(Icons.gif), onPressed: () {}),
                            IconButton(
                                icon: Icon(MyCustomeIcons.smile),
                                onPressed: () {}),
                          ],
                        ),
                      )
                    ],
                  )),
            )
          ],
        )),
      ),
    );
  }
}
