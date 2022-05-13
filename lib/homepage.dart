//Written by PK
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/Animation/FadeAnimation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/forgotpassword.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'signup.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dashboard.dart';
class HomePage extends StatelessWidget {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final devheight = MediaQuery.of(context).size.height;
    final devwidth = MediaQuery.of(context).size.width;
    double getheight(double val){
      return (val/770.6)*devheight;
    }
    double getwidth(double val){
      return (val/360.0)*devwidth;
    }
    FirebaseAuth.instance.currentUser?.reload();
    StreamSubscription<User?> authManager = FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
      } else {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => Dashboard(),
          ),
        );
      }
    });

    Future<User?> signInWithGoogle() async {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user;

      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
          await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('The account already exists with a different credential.'),
            )
            );
          }
          else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Invalid Credentials'),
            )
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Error'),
          )
          );
        }
      }

      return user;
    }



    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
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
                        child: Text("Login", style: GoogleFonts.montserrat(fontSize: 50,color: Colors.white),),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(getwidth(30.0)),
                child: Column(
                  children: <Widget>[
                    FadeAnimation(1.8, Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromRGBO(186, 221, 245, 0.7),
                                blurRadius: 30.0,
                                offset: Offset(0, 10)
                            )
                          ]
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey.shade100))
                            ),
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
                                  hintText: "Email",
                                  hintStyle: TextStyle(color: Colors.grey[400])
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _password,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              autocorrect: false,
                              enableSuggestions: false,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey[400])
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                    ),
                    SizedBox(height: getheight(15).floorToDouble(),),
                    FadeAnimation(1.5,
                        Padding(
                          padding: EdgeInsets.only(left: getwidth(150)),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPassword()));
                              },
                              child: const Text("Forgot Password?", style: TextStyle(color: Color.fromRGBO(186, 221, 245, 1.0)),)
                          ),
                        )
                    ),
                    SizedBox(height: getheight(30.0),),
                    FadeAnimation(2,
                        GestureDetector(
                          onTap: () async {
                            _signin();
                          },
                          child: Container(
                            height: getheight(50.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                    colors: [
                                      Color.fromRGBO(186, 221, 245, 1.0),
                                      Color.fromRGBO(186, 221, 245, 0.6),
                                    ]
                                )
                            ),
                            child: const Center(
                              child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            ),
                          ) ,
                        )
                    ),
                    SizedBox(height: getheight(25),),
                    FadeAnimation(1.5, Stack(
                        children:  [
                          Divider(
                            height: getheight(16).floorToDouble(),
                            thickness: 1.7,
                            endIndent: getwidth(205.0),
                          ),
                          Center(child: Text('or continue with', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center,)),
                          Divider(
                            height: getheight(16).floorToDouble(),
                            thickness: 1.7,
                            indent: getwidth(205.0),
                          ),
                        ]
                    ),),
                    SizedBox(height: getheight(30.0),),
                    FadeAnimation(1.5,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                              onTap: () {
                                signInWithGoogle();
                              },
                              child: Container(
                                height: getheight(50.0),
                                width: getwidth(50.0),
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/images/google.png')
                                    )
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: getheight(40.0),),
                    FadeAnimation(1.5,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            const Text("Don't have an account?", style: TextStyle(color: Colors.grey)),
                            SizedBox(width: getwidth(10.0),),
                            GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));
                                    },
                                    child: const Text("Register here", style: TextStyle(color: Color.fromRGBO(186, 221, 245, 1.0)),)
                                ),
                            SizedBox(width: getwidth(8.0),),

                          ],
                        ),
                        ),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
  Future<void> _signin() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text,
          password: _password.text
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
      } else if (e.code == 'wrong-password') {
      }
    }
  }
}