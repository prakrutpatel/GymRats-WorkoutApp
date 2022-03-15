import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'Animation/FadeAnimation.dart';
import 'homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Dashboard extends StatelessWidget {
  @override
  int _num = 0;

  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    StreamSubscription<User?> authManager = FirebaseAuth.instance.userChanges()
        .listen((User? user) {
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

    return Scaffold(
        drawer: SidebarX(
          controller: SidebarXController(selectedIndex: 0, extended: true),
          theme: SidebarXTheme(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromRGBO(143, 148, 251, .6),
              borderRadius: BorderRadius.circular(20),
            ),
            textStyle: const TextStyle(color: Color.fromRGBO(143, 148, 251, .8)),
            selectedTextStyle: const TextStyle(color: Colors.white),
            itemTextPadding: const EdgeInsets.only(left: 30),
            selectedItemTextPadding: const EdgeInsets.only(left: 30),
            itemDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color.fromRGBO(143, 148, 251, .6)),
            ),
            selectedItemDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color.fromRGBO(143, 148, 251, .2).withOpacity(0.37),
              ),
              gradient: const LinearGradient(
                colors: [
                  Color.fromRGBO(143, 148, 251, 1),
                  Color.fromRGBO(143, 148, 251, .6),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.20),
                  blurRadius: 20,
                )
              ],
            ),
            iconTheme: const IconThemeData(
              color: Color(0xFF2E2E48),
              size: 20,
            ),
          ),
          extendedTheme: const SidebarXTheme(
            width: 250,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            margin: EdgeInsets.only(right: 10),
          ),
          footerDivider:
              Divider(color: Colors.purple.withOpacity(0.3), height: 1),
          headerBuilder: (context, extended) {
            return SafeArea(
              child: SizedBox(
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset('assets/images/user_placeholder.png'),
                ),
              ),
            );
          },
          items: [
            SidebarXItem(icon: Icons.email, label: auth.currentUser!.email),
            SidebarXItem(icon: Icons.account_box_outlined, label: "Prakrut"),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
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
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade100))
                              ),
                              child: Text(('First')),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: Text(('Second')),
                            )
                          ],
                        ),
                      )
                      ),
                      SizedBox(height: 20,),
                      FadeAnimation(2,
                          GestureDetector(
                            onTap: () async {
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(143, 148, 251, 1),
                                        Color.fromRGBO(143, 148, 251, .4),
                                      ]
                                  )
                              ),
                              child: Center(
                                child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                              ),
                            ) ,
                          )
                      ),
                      SizedBox(height: 60,),
                      FadeAnimation(1.5,
                          GestureDetector(
                              onTap: () async {
                                await _signOut();
                              },
                              child: Text("Forgot Password?", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),)
                          )
                      ),
                      SizedBox(height: 25,),
                      FadeAnimation(1.5,
                          GestureDetector(
                              onTap: () {
                              },
                              child: Text("Not a user", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),)
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
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

