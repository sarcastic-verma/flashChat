import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/roundedButton.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "/loginScreen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool showSpinner = false;
  bool isRight = true;
  TextEditingController passwordController = TextEditingController();
  String passwordHintText = "Enter your password";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: "logo",
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  autocorrect: true,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: "Enter your email"),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  controller: passwordController,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: isRight
                      ? kTextFieldDecoration.copyWith(
                          hintText: passwordHintText)
                      : kTextFieldDecoration.copyWith(
                          hintText: passwordHintText,
                          hintStyle: TextStyle(color: Colors.red),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.redAccent, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          )),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  color: Colors.amber,
                  text: "Log In",
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (user != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    } on PlatformException catch (e) {
                      if (e.toString() ==
                          "PlatformException(ERROR_WRONG_PASSWORD, The password is invalid or the user does not have a password., null)") {
                        setState(() {
                          passwordController.clear();
                          passwordHintText = "Wrong Password";
                          showSpinner = false;
                          isRight = false;
                        });
                      } else if (e.toString() ==
                          "PlatformException(ERROR_USER_NOT_FOUND, There is no user record corresponding to this identifier. The user may have been deleted., null)") {
                        setState(() {
                          showSpinner = false;
                        });
                        await Alert(
                            context: context,
                            title: "User Not Found",
                            desc: "Register to continue!!",
                            buttons: [
                              DialogButton(
                                gradient: LinearGradient(colors: [
                                  Colors.deepOrange,
                                  Colors.amberAccent
                                ]),
                                child: Text(
                                  "COOL, I'll Register.",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                onPressed: () => Navigator.popAndPushNamed(
                                    context, RegistrationScreen.id),
                                width: 150,
                              )
                            ]).show();
                      } else {
                        setState(() {
                          showSpinner = false;
                        });
                        await Alert(
                            context: context,
                            title: "Congratulations,an Unknow Error",
                            desc: e.toString(),
                            buttons: [
                              DialogButton(
                                gradient: LinearGradient(colors: [
                                  Colors.deepOrange,
                                  Colors.amberAccent
                                ]),
                                child: Text(
                                  "SS to developer",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                onPressed: () => Navigator.popAndPushNamed(
                                    context, LoginScreen.id),
                                width: 150,
                              )
                            ]).show();
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//todo :implement OAuth
