//Written by PK
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/Animation/FadeAnimation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/information_page.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'homepage.dart';
class SignUp extends StatelessWidget {
  @override
  var _email = TextEditingController();
  var _password = TextEditingController();
  var _confirm_password = TextEditingController();
  RegExp regExp = new RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$',
    caseSensitive: false,
    multiLine: false,
  );

  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser?.reload();
    StreamSubscription<User?> authManager = FirebaseAuth.instance.userChanges()
        .listen((User? user) async {
      if (user == null) {
      } else {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => Additional_Info_Screen(),
          ),
        );
      }
    });

    Future<void> showMyDialogforUserfound() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        useSafeArea: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Authentication Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('User already signed up.'),
                  Text('Try logging in or reset password.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> showMyDialogforInvalidPassword() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        useSafeArea: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Password Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Passwords do not match'),
                  Text('Try again.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> showMyDialogforWeakPassword() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        useSafeArea: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Password Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Weak password is used'),
                  Text('Try again with a stronger password.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> _signup() async {
      if ((_password.text == _confirm_password.text) &&
          (regExp.hasMatch(_password.text))) {
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
              email: _email.text,
              password: _password.text
          );
          if (userCredential.additionalUserInfo!.isNewUser) {
            //User logging in for the first time
            // Redirect user to tutorial

          }
          else{

          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            print('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            showMyDialogforUserfound();
          }
        } catch (e) {
          print(e);
        }
      }
      else {
        if ((_password.text != _confirm_password.text)) {
          showMyDialogforInvalidPassword();
        }
        if ((regExp.hasMatch(_password.text))) {
          showMyDialogforWeakPassword();
        }
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill
                      )
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeAnimation(1, Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/light-1.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(1.3, Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/light-2.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(1.5, Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/clock.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        child: FadeAnimation(1.6, Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text("Sign Up", style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold),),
                          ),
                        )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(1.8, Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10)
                              )
                            ]
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(
                                      color: Colors.grey.shade100))
                              ),
                              child: TextFormField(
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                autovalidateMode: AutovalidateMode
                                    .onUserInteraction,
                                validator: Validators.compose([
                                  Validators.required('Email is required'),
                                  Validators.email('Invalid email address'),
                                ]),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(
                                      color: Colors.grey.shade100))
                              ),
                              child: TextFormField(
                                controller: _password,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                autocorrect: false,
                                enableSuggestions: false,
                                autovalidateMode: AutovalidateMode
                                    .onUserInteraction,
                                validator: Validators.compose([
                                  Validators.required('Password is required'),
                                  Validators.patternString(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$',
                                      'Invalid Password')
                                ]),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _confirm_password,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                autocorrect: false,
                                enableSuggestions: false,
                                autovalidateMode: AutovalidateMode
                                    .onUserInteraction,
                                validator: Validators.compose([
                                  Validators.required('Password is required'),
                                  Validators.patternString(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$',
                                      'Invalid Password')
                                ]),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Confirm Password",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                      ),
                      SizedBox(height: 20,),
                      FadeAnimation(2,
                          GestureDetector(
                            onTap: () async {
                              _signup();
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(143, 148, 251, 1),
                                        Color.fromRGBO(143, 148, 251, .6),
                                      ]
                                  )
                              ),
                              child: Center(
                                child: Text("Sign Up", style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),),
                              ),
                            ),
                          )
                      ),
                      SizedBox(height: 25,),
                      FadeAnimation(1.5,
                          GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement<void, void>(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        HomePage(),
                                  ),
                                );
                              },
                              child: Text(
                                "Log in?", style: TextStyle(color: Color
                                  .fromRGBO(143, 148, 251, 1)),)
                          )
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}