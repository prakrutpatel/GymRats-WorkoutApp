//Written by PK
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/Animation/FadeAnimation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'homepage.dart';


class ForgotPassword extends StatelessWidget {
  @override
  final _email = TextEditingController();
  String _errorname = "";
  Widget build(BuildContext context) {
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Email not found'),
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
    Future _passwordReset() async {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _email.text);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          _showMyDialog();
        }
      }
    }
    final devheight = MediaQuery.of(context).size.height;
    final devwidth = MediaQuery.of(context).size.width;
    double getheight(double val){
      return (val/770.6)*devheight;
    }
    double getwidth(double val){
      return (val/360.0)*devwidth;
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: getheight(250.0),
                  child: Stack(
                    children: [
                      Container(
                          height: getheight(200),
                          color: Color.fromRGBO(186, 221, 245, 1.0)
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:getheight(165.0).floorToDouble()),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Container(
                            height: getheight(100.0),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        height: getheight(200.0),
                        child: Center(
                          child: Text("Forgot Password", style: GoogleFonts.montserrat(fontSize: 40,color: Colors.white),),
                        ),
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
                              height: 50.0,
                              child: TextFormField(
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: Validators.compose([
                                  Validators.required('Email is required'),
                                  Validators.email('Invalid email address'),
                                ]),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 0.0),
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    errorText: _errorname
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      ),
                      SizedBox(height: 20,),
                      FadeAnimation(2,
                          GestureDetector(
                            onTap: () async {
                              var wait = await _passwordReset();
                              Timer(Duration(seconds: 3), () {
                                Navigator.pushReplacement<void, void>(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) => HomePage(),
                                  ),
                                );
                              });

                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(186, 221, 245, 1.0),
                                        Color.fromRGBO(186, 221, 245, 0.6),
                                      ]
                                  )
                              ),
                              child: Center(
                                child: Text("Send Email", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                              ),
                            ) ,
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
                                  .fromRGBO(186, 221, 245, 1.0)),)
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