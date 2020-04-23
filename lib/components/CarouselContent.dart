import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Content extends StatelessWidget {
  final String title;
  final bool showButton;
  final String desc;
  final bool showImage;
  final double height;
  final double width;
  final String imageName;
  Content(
      {@required this.title,
      this.height,
      this.width,
      this.imageName,
      this.showButton,
      this.desc,
      this.showImage});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.amber,
                fontSize: 50,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          Text(desc,
              style: TextStyle(
                  height: 1.5,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
              textAlign: TextAlign.center),
          showImage == true
              ? Image(
                  width: width,
                  height: height,
                  image: AssetImage("images/$imageName.png"),
                )
              : SizedBox(
                  height: 0,
                  width: 0,
                ),
          showButton == true
              ? RaisedButton(
                  elevation: 5,
                  onPressed: () async {
                    await Navigator.pushNamed(context, WelcomeScreen.id);
                  },
                  color: Colors.amber,
                  child: Text("Lets get going",
                      style: TextStyle(), textAlign: TextAlign.center),
                )
              : SizedBox(
                  height: 0,
                  width: 0,
                )
        ],
      ),
    );
  }
}
