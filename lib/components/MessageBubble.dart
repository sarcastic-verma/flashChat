import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'DeleteButton.dart';

final _fireStore = Firestore.instance;

class MessageBubble extends StatefulWidget {
  MessageBubble(
      {this.time,
      this.likeCount,
      this.disLikeCount,
      this.sender,
      this.text,
      this.isMe,
      this.id,
      this.isDeleted,
      this.disliked,
      this.liked});
  final String time;
  final int disLikeCount;
  final int likeCount;
  final String text;
  final String sender;
  final bool isMe;
  final String id;
  final bool isDeleted;
  final bool liked;
  final bool disliked;
  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool showDel = false;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showDel = false;
        });
      },
      onHorizontalDragEnd: (dragStartDetails) async {
        try {
          await _fireStore
              .collection("messages")
              .document(widget.id)
              .updateData(
                  {"disLiked": true, "disLikeCount": widget.disLikeCount + 1});
          setState(() {});
        } catch (e) {
          print(e);
        }
      },
      onDoubleTap: () async {
        try {
          await _fireStore
              .collection("messages")
              .document(widget.id)
              .updateData({"liked": true, "likeCount": widget.likeCount + 1});
          setState(() {});
        } catch (e) {
          print(e);
        }
      },
      onLongPress: () {
        setState(() {
          showDel = true;
        });
      },
      child: widget.isMe != null &&
              widget.isDeleted != null &&
              widget.isMe &&
              widget.isDeleted
          ? FillerBox()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: widget.isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.time,
                      style: TextStyle(color: Colors.black45, fontSize: 12.0)),
                  Text(widget.isMe ? "you" : widget.sender,
                      style: TextStyle(color: Colors.black54, fontSize: 13.0)),
                  widget.isMe
                      ? showDel
                          ? DeleteButton(
                              color: Colors.grey,
                              text: "Delele 4 all",
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
                          : FillerBox()
                      : FillerBox(),
                  widget.isMe
                      ? showDel
                          ? DeleteButton(
                              color: Colors.grey,
                              text: "Delete 4 me",
                              onPressed: () async {
                                try {
                                  await _fireStore
                                      .collection("messages")
                                      .document(widget.id)
                                      .updateData({"isDeleted": true});
                                  setState(() {
                                    showDel = false;
                                  });
                                } catch (e) {
                                  print(e);
                                }
                              })
                          : FillerBox()
                      : FillerBox(),
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
                        softWrap: true,
                        style: widget.isMe
                            ? TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              )
                            : TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: widget.isMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      widget.id != null && widget.likeCount > 0 && widget.liked
                          ? BottomLiker(
                              widget: widget,
                              onPressed: () async {
                                await _fireStore
                                    .collection("messages")
                                    .document(widget.id)
                                    .updateData({
                                  "likeCount": widget.likeCount - 1,
                                });
                              },
                            )
                          : FillerBox(),
                      widget.id != null &&
                              widget.disLikeCount > 0 &&
                              widget.disliked
                          ? BottomDisLiker(
                              widget: widget,
                              onPressed: () async {
                                await _fireStore
                                    .collection("messages")
                                    .document(widget.id)
                                    .updateData({
                                  "disLikeCount": widget.disLikeCount - 1
                                });
                              },
                            )
                          : FillerBox(),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class BottomDisLiker extends StatelessWidget {
  BottomDisLiker({this.widget, this.onPressed});
  final MessageBubble widget;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          widget.disLikeCount.toString(),
          style: TextStyle(
            fontSize: 15,
          ),
          textAlign: widget.isMe ? TextAlign.right : TextAlign.center,
        ),
        IconButton(
          alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
          icon: FaIcon(
            FontAwesomeIcons.thumbsDown,
            color: Colors.black,
            size: 15,
          ),
          onPressed: onPressed,
        ),
      ],
    );
  }
}

class BottomLiker extends StatelessWidget {
  BottomLiker({this.widget, this.onPressed});
  final MessageBubble widget;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          widget.likeCount.toString(),
          style: TextStyle(
            fontSize: 15,
          ),
          textAlign: TextAlign.right,
        ),
        IconButton(
          alignment: Alignment.centerLeft,
          icon: FaIcon(
            FontAwesomeIcons.heart,
            size: 15,
            color: Colors.red,
          ),
          onPressed: onPressed,
        ),
      ],
    );
  }
}

class FillerBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0,
      width: 0,
    );
  }
}
