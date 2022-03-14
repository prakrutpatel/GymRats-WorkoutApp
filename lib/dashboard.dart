import 'dart:async';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Dashboard extends StatelessWidget {
  @override
  int _num = 0;
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    StreamSubscription<User?> authManager = FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null && _num == 0) {
        _num = 1;
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => HomePage(),
          ),
        );
      } else {
        print('User is currently signed in');
      }
    });
    final avatar = Padding(
      padding: EdgeInsets.all(20),
      child: Hero(
          tag: 'logo',
          child: SizedBox(
            height: 160,
            child: RichText(
              text: TextSpan(
                  text: auth.currentUser!.email,
                  style: TextStyle(color: Colors.black, fontSize: 20)
              ),

            ),
          )
      ),
    );
    final description = Padding(
      padding: EdgeInsets.all(10),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
            text: auth.currentUser!.uid,
            style: TextStyle(color: Colors.black, fontSize: 20)
        ),
      ),
    );
    final buttonLogout = TextButton(
        child: Text('Logout', style: TextStyle(color: Colors.black87, fontSize: 16),),
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
        }
    );
    return SafeArea(
        child: Scaffold(
          body: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: <Widget>[
                avatar,
                description,
                buttonLogout
              ],
            ),
          ),
        )
    );
  }
}