import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/roundedButton.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "/registerScreen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email;
  String name;
  String password;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      name = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: "Sassy Username"),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: "Valid/Dummy EmailId"),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: ">=6-Digit-Password")),
                  SizedBox(
                    height: 24.0,
                  ),
                  RoundedButton(
                      color: Colors.deepOrangeAccent,
                      text: "Register",
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final newUser =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                          FirebaseUser user = await _auth.currentUser();
                          UserUpdateInfo userInfo = UserUpdateInfo();
                          userInfo.displayName = name;
                          await user.updateProfile(userInfo);
                          if (newUser != null) {
                            Navigator.pushNamed(context, ChatScreen.id);
                          }
                          setState(() {
                            showSpinner = false;
                          });
                        } catch (e) {
                          print(e);
                          setState(() {
                            showSpinner = false;
                          });
                          if (e.toString() ==
                              "PlatformException(ERROR_WEAK_PASSWORD, The given password is invalid. [ Password should be at least 6 characters ], null)") {
                            Alert(
                                context: context,
                                title: "Ah, a lazy one!",
                                desc:
                                    "Please choose atleast a 6 digit password...",
                                buttons: [
                                  DialogButton(
                                    gradient: LinearGradient(colors: [
                                      Colors.deepOrange,
                                      Colors.amberAccent
                                    ]),
                                    child: Text(
                                      "Ohk,lets TYPE",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                    onPressed: () => Navigator.popAndPushNamed(
                                        context, RegistrationScreen.id),
                                    width: 150,
                                  )
                                ]).show();
                          }
                          if (e.toString() ==
                              "PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null)") {
                            Alert(
                                context: context,
                                title: "Doppelganger?",
                                desc:
                                    "The email already exists, try with another email.",
                                buttons: [
                                  DialogButton(
                                    gradient: LinearGradient(colors: [
                                      Colors.deepOrange,
                                      Colors.amberAccent
                                    ]),
                                    child: Text(
                                      "Ok,Detective!!",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                    onPressed: () => Navigator.popAndPushNamed(
                                        context, RegistrationScreen.id),
                                    width: 150,
                                  )
                                ]).show();
                          }
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
