import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/workout.dart';
import 'package:sidebarx/sidebarx.dart';
import 'Animation/FadeAnimation.dart';
import 'calendar.dart';
import 'homepage.dart';
import 'workout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animations/animations.dart';


class Dashboard extends StatelessWidget {
  @override
  int _num = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
        key: _scaffoldKey,
        drawer: SidebarX(
          controller: SidebarXController(selectedIndex: 0, extended: true),
          theme: SidebarXTheme(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromRGBO(143, 148, 251, .6),
              borderRadius: BorderRadius.circular(20),
            ),
            textStyle: const TextStyle(color: Colors.white),
            selectedTextStyle: const TextStyle(color: Colors.white),
            itemTextPadding: const EdgeInsets.only(left: 30),
            selectedItemTextPadding: const EdgeInsets.only(left: 30),
            itemDecoration: BoxDecoration(
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
          headerBuilder: (context, extended) {
            return SafeArea(
              child: SizedBox(
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                  child: Column(
                      children: <Widget>[
                        Image.asset('assets/images/user_placeholder.png', height: 100, width: 100, semanticLabel: "name",),
                        SizedBox(height: 10.0),
                        Text((auth.currentUser!.email ?? ""))
                      ]
                  ),
                ),
              ),
            );
          },
          items: [
            SidebarXItem(icon: Icons.calendar_today_outlined,
                label: "Calender",
              onTap: () {
                {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Calendar(title: '')));
                }
            }
            ),
            SidebarXItem(icon: Icons.account_box_outlined,
                label: "Workout Menu",
                onTap: () {
                  {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Workout_Menu()));
                  }
                }
            ),
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

