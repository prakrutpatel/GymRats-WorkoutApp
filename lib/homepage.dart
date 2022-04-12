//Written by PK
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/Animation/FadeAnimation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/forgotpassword.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'signup.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dashboard.dart';
class HomePage extends StatelessWidget {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                height: 300,
                decoration: const BoxDecoration(
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
                        decoration: const BoxDecoration(
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
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: const AssetImage('assets/images/light-2.png')
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
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/clock.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      child: FadeAnimation(1.6, Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: const Center(
                          child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                        ),
                      )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    FadeAnimation(1.8, Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromRGBO(186, 221, 245, 0.2),
                                blurRadius: 20.0,
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
                    const SizedBox(height: 15,),
                    FadeAnimation(1.5,
                        Padding(
                          padding: const EdgeInsets.only(left: 175.0),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPassword()));
                              },
                              child: const Text("Forgot Password?", style: TextStyle(color: Color.fromRGBO(186, 221, 245, 1.0)),)
                          ),
                        )
                    ),
                    const SizedBox(height: 30,),
                    FadeAnimation(2,
                        GestureDetector(
                          onTap: () async {
                            _signin();
                          },
                          child: Container(
                            height: 50,
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
                    const SizedBox(height: 25,),
                    FadeAnimation(1.5, Stack(
                        children: const [
                          Divider(
                            thickness: 1.7,
                            endIndent: 205.0,
                          ),
                          Center(child: Text('or continue with', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center,)),
                          Divider(
                            thickness: 1.7,
                            indent: 205.0,
                          ),
                        ]
                    ),),
                    const SizedBox(height: 30.0,),
                    FadeAnimation(1.5,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                              onTap: () {
                                signInWithGoogle();
                              },
                              child: Container(
                                height: 50.0,
                                width: 50.0,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/images/google.png')
                                    )
                                ),
                              )
                          ),
                          GestureDetector(
                              onTap: () {
                              },
                              child: Container(
                                height: 50.0,
                                width: 50.0,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/images/twitter.png')
                                    )
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30.0,),
                    FadeAnimation(1.5,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            const Text("Don't have an account?", style: TextStyle(color: Colors.grey)),
                            const SizedBox(width: 10.0,),
                            GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));
                                    },
                                    child: const Text("Register here", style: TextStyle(color: Color.fromRGBO(186, 221, 245, 1.0)),)
                                ),
                            const SizedBox(width: 8.0,),

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
    if (_email.text == 't') {
      _email.text = 'test@test.com';
      _password.text = 'Testuser123';
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text,
          password: _password.text
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}