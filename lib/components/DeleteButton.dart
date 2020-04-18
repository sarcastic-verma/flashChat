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
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20)),
        child: MaterialButton(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          onPressed: onPressed,
          minWidth: 10.0,
          height: 10.0,
          child: Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
