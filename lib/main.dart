import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

import 'screens/chat_screen.dart';
import 'screens/intro.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/splash_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
          primaryColor: Colors.teal, buttonColor: Colors.black87),
      initialRoute: SplashScreen.id,
      routes: {
        IntroScreen.id: (context) => IntroScreen(),
        SplashScreen.id: (context) => SplashScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen()
      },
    );
  }
}
