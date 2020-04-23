//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/MessageBubble.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

final _fireStore = Firestore.instance;
FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = "/chatScreen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  String messageText;
////  File _image;
//
//  Future getImage() async {
//    dynamic image = await ImagePicker.pickImage(source: ImageSource.camera);
//
//    setState(() {
////      _image = image;
//    });
//  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    try {
      loggedInUser = await _auth.currentUser();
    } catch (e) {
      print(e);
    }
  }

  final TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.deepOrange),
        leading: null,
        actions: <Widget>[
//          IconButton(
//            padding: EdgeInsets.all(8),
//            icon: FaIcon(
//              FontAwesomeIcons.cameraRetro,
//            ),
//            onPressed: () {},
//            tooltip: "Upload Media(Beta)",
//          ),
//          SizedBox(
//            width: 20,
//          ),
          IconButton(
              icon: FaIcon(
                FontAwesomeIcons.signOutAlt,
              ),
              tooltip: "Logout",
              onPressed: () async {
                await _auth.signOut();
                Navigator.popAndPushNamed(context, WelcomeScreen.id);
              }),
        ],
        title: Text('             ⚡️', style: TextStyle(fontSize: 30)),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamMessage(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      autocorrect: true,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      controller: messageController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: RaisedButton(
                      color: Colors.white,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      onPressed: () async {
                        messageController.clear();
                        if (messageText.isEmpty != true) {
                          await _fireStore.collection("messages").add({
                            "likeCount": 0,
                            "disLikeCount": 0,
                            "liked": false,
                            "disLiked": false,
                            "text": messageText,
                            "sender": loggedInUser.email,
                            "timeStamp": DateTime.now().millisecondsSinceEpoch,
                            'username': loggedInUser.displayName,
                            "isDeleted": false
                          });
                          messageText = null;
                        }
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.deepOrange,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StreamMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            _fireStore.collection("messages").orderBy('timeStamp').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.amberAccent,
              ),
            );
          }
          final messages = snapshot.data.documents.reversed;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final messageText = message.data["text"];
            final messageSender = message.data["sender"];
            final messageUserName = message.data["username"];
            final currentUser = loggedInUser.email;
            final messageTime = message.data['timeStamp'];
            final messageId = message.documentID;
            final liked = message.data["liked"];
            final disLiked = message.data["disLiked"];
            final isDeleted = message.data["isDeleted"];
            final likeCount = message.data["likeCount"];
            final dislikeCount = message.data["disLikeCount"];
            DateTime date = DateTime.fromMillisecondsSinceEpoch(messageTime);
            final format = DateFormat('HH:mm');
            final messTime = format.format(date);
            final messageBubble = MessageBubble(
                likeCount: likeCount,
                disLikeCount: dislikeCount,
                text: messageText,
                id: messageId,
                sender: messageUserName,
                isDeleted: isDeleted,
                time: messTime,
                liked: liked,
                disliked: disLiked,
                isMe: currentUser == messageSender);
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 10.0),
              children: messageBubbles,
            ),
          );
        });
  }
}
//todo : Add notifications
//todo: add camera feature
