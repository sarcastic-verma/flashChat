import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/MessageBubble.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';

final _fireStore = Firestore.instance;
FirebaseUser loggedInUser;
String messageId;

class ChatScreen extends StatefulWidget {
  static const String id = "/chatScreen";
  static String getID() {
    return messageId;
  }

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  String messageText;
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
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                await _auth.signOut();
                Navigator.popAndPushNamed(context, WelcomeScreen.id);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.deepOrange,
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
                      color: Colors.amber,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      onPressed: () async {
                        messageController.clear();
                        if (messageText.isEmpty != true) {
                          DocumentReference ref =
                              await _fireStore.collection("messages").add({
                            "text": messageText,
                            "sender": loggedInUser.email,
                            "timeStamp": DateTime.now().millisecondsSinceEpoch,
                            'username': loggedInUser.displayName,
                          });
                          messageId = ref.documentID;
                          messageText = null;
                          print(messageText);
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
            DateTime date = DateTime.fromMillisecondsSinceEpoch(messageTime);
            final format = DateFormat('HH:mm');
            final messTime = format.format(date);
            final messageBubble = MessageBubble(
                text: messageText,
                id: messageId,
                sender: messageUserName,
                time: messTime,
                isMe: currentUser == messageSender);
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              children: messageBubbles,
            ),
          );
        });
  }
}
