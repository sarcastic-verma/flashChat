import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/roundedButton.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "/";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  Animation colorAnimation;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInCubic);
    colorAnimation =
        ColorTween(begin: Colors.orange, end: Colors.white).animate(controller);
    controller.forward();
//    animation.addStatusListener((status) {   // used for continuous animation
//      if (status == AnimationStatus.completed) {
//        controller.reverse(from: 1.0);
//      }
//      if (status == AnimationStatus.dismissed) {
//        controller.forward();
//      }
//    });
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAnimation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: "logo",
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: animation.value * 90,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  isRepeatingAnimation: false,
                  duration: Duration(seconds: 4),
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
                color: Colors.amber, text: "Log In", route: LoginScreen.id),
            RoundedButton(
              color: Colors.deepOrange,
              text: "Register",
              route: RegistrationScreen.id,
            ),
          ],
        ),
      ),
    );
  }
}
