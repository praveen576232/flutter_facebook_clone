import 'package:flutter/material.dart';

class Status extends StatefulWidget {
  String status;
  String userName;
  String userUrl;
  Status(
      {@required this.status, @required this.userName, @required this.userUrl});

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> with SingleTickerProviderStateMixin {
 

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: 100,
            width: 125,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.status), fit: BoxFit.fill),
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[200]),
            child: Stack(
              children: [
                Positioned(
                    top: 10,
                    left: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      backgroundImage: NetworkImage(widget.userUrl),
                    )),
                Positioned(
                    bottom: 8,
                    left: 5,
                    child: Container(
                        width: 125,
                        child: Text(
                          widget.userName != null ? widget.userName : '',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )))
              ],
            )));
  }
}
