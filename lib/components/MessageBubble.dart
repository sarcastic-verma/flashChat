import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/DeleteButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final _fireStore = Firestore.instance;

class MessageBubble extends StatefulWidget {
  MessageBubble({this.time, this.sender, this.text, this.isMe, this.id});
  final String time;
  final String text;
  final String sender;
  final bool isMe;
  final String id;

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool showDel = false;
  bool isDeleted = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          showDel = false;
        });
      },
      onLongPress: () {
        setState(() {
          showDel = true;
        });
      },
      child: isDeleted
          ? SizedBox(
              width: 0,
              height: 0,
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: widget.isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.time,
                      style: TextStyle(color: Colors.black45, fontSize: 10.0)),
                  Text(widget.isMe ? "You" : widget.sender,
                      style: TextStyle(color: Colors.black54, fontSize: 14.0)),
                  widget.isMe
                      ? showDel
                          ? DeleteButton(
                              color: Colors.grey,
                              text: "Del 4 all",
                              onPressed: () async {
                                try {
                                  await _fireStore
                                      .collection("messages")
                                      .document(widget.id)
                                      .delete();
                                  setState(() {
                                    print("${widget.id} in setState");
                                    showDel = false;
//                                    isDeleted = true;
                                  });
                                  print("deleted");
                                } catch (e) {
                                  print(e);
                                }
                              })
                          : SizedBox(
                              height: 0,
                              width: 0,
                            )
                      : SizedBox(
                          height: 0,
                          width: 0,
                        ),
                  Material(
                    borderRadius: widget.isMe
                        ? BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          )
                        : BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                    elevation: 10.0,
                    color: widget.isMe ? Colors.amberAccent : Colors.white70,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Text(
                        widget.text,
                        style: widget.isMe
                            ? TextStyle(fontSize: 15, color: Colors.black)
                            : TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                    ),
                  ),
                  widget.isMe
                      ? showDel
                          ? DeleteButton(
                              color: Colors.grey,
                              text: "Del 4 me",
                              onPressed: () async {
                                try {
                                  setState(() {
                                    showDel = false;
                                    isDeleted = true;
                                  });
                                  print("deleted");
                                } catch (e) {
                                  print(e);
                                }
                              })
                          : SizedBox(
                              height: 0,
                              width: 0,
                            )
                      : SizedBox(
                          height: 0,
                          width: 0,
                        ),
                ],
              ),
            ),
    );
  }
}
