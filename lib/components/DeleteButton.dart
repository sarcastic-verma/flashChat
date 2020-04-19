import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onPressed;
  DeleteButton({this.onPressed, this.text, this.color});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Material(
        elevation: 1,
        color: color,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            bottomRight: Radius.circular(60),
            topRight: Radius.circular(60),
            bottomLeft: Radius.circular(60)),
        child: MaterialButton(
          padding: EdgeInsets.symmetric(horizontal: 3),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: 11),
          ),
        ),
      ),
    );
  }
}
