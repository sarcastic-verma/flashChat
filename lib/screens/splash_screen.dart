import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/services/auth.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = "/splashScreen";
  @override
  _Splash createState() => _Splash();
}

class _Splash extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          value: null,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _handleStartScreen();
  }

  Future<void> _handleStartScreen() async {
    Auth _auth = Auth();
    if (await _auth.isLoggedIn()) {
      Navigator.popAndPushNamed(context, ChatScreen.id);
    } else {
      Navigator.popAndPushNamed(context, WelcomeScreen.id);
    }
  }
}
