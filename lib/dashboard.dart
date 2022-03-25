import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/settings.dart';
import 'package:flutter_app/workout.dart';
import 'package:sidebarx/sidebarx.dart';
import 'Animation/FadeAnimation.dart';
import 'calendar.dart';
import 'homepage.dart';
import 'Tutorial/onboarding_screen.dart';
import 'workout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animations/animations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Dashboard extends StatefulWidget{
  _Dashboard createState()=> _Dashboard();
}
class _Dashboard extends State<Dashboard>{
  @override
  int _num = 0;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  String _name = '';
  late File _imageFile;
  String profile_image_url = '';


  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final ref = FirebaseDatabase.instance.ref();
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
      }
    });

    Future<String> dbInfo({required String path}) async {
      final snapshot = await ref.child('users/'+ auth.currentUser!.uid+"/"+path).get();
      if (snapshot.exists) {
       return snapshot.value.toString();
      } else {
        print('No data available.');
        return "";
      }
    }
    dbInfo(path: 'name').then((String result){
      _name = result;
    });

    final picker = ImagePicker();
    Future uploadImageToFirebase(BuildContext context) async {
      try {
        String url;
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref().child('uploads/'+ auth.currentUser!.uid);
        UploadTask uploadTask = ref.putFile(_imageFile);
        uploadTask.then((res) {
          res.ref.getDownloadURL();
        });
        try {
          var res = await uploadTask.whenComplete(() {
            ref.getDownloadURL().then((String url1) {
            });
          });
          setState(() {});
        } on FirebaseException catch (error) {
          print(error);
        }
      } catch (err){
        print(err);
      }
  }

    Future<String> networkImage() async {
      final ref = FirebaseStorage.instance.ref().child('uploads/'+ auth.currentUser!.uid);
      try {
        var url = await ref.getDownloadURL();
        return url as String;
      }
      catch (e) {
        return '';
      }
    }

    Future pickImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        _imageFile = File(pickedFile!.path);
      });
      await uploadImageToFirebase(context);
    }
    networkImage().then((String result){
      profile_image_url = result;
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
          footerDivider: SizedBox(
            height: 5.0,
            width: 5.0,
            child: Padding(
              padding: const EdgeInsets.only(right: 190.0),
              child: IconButton(icon: const Icon(Icons.settings_suggest_outlined),iconSize: 30.0, onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
              },),
            ),
          ),
          headerBuilder: (context, extended) {
            networkImage();
            return SafeArea(
              top: true,
              minimum: EdgeInsets.zero,
              child: SizedBox(
                height: 190,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            pickImage();

                          },
                          child: CachedNetworkImage(
                            imageUrl: profile_image_url,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const CircleAvatar(
                              backgroundImage: AssetImage('assets/images/user_placeholder.png'),
                            ),
                            useOldImageOnUrlChange: true,
                            height: 137,
                            width: 150,
                          ),
                        ),
                        SizedBox(height: 7.0),
                        GestureDetector(
                          child: Text(_name,
                              style: const TextStyle(height: 1.2,fontSize: 25),
                            ),
                        )
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
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ExerciseList()));
                  }
                }
            ),
            SidebarXItem(icon: Icons.logout_rounded,
                label: "Logout",
                onTap: () async {
                  {
                    await _signOut();
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
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
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
                                child: Text("Settings Screen", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                              ),
                            ) ,
                          )
                      ),
                      SizedBox(height: 60,),
                      FadeAnimation(1.5,
                          GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text('snack'),
                                  shape: RoundedRectangleBorder(

                                  ),
                                  duration: Duration(seconds: 2),

                                ));
                              },
                              child: Text("Snack Bar", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),)
                          )
                      ),
                      SizedBox(height: 25,),
                      FadeAnimation(1.5,
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => OnboardingScreen()));
                              },
                              child: Text("Onboarding", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),)
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

class _ExampleAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text('Alert Dialog'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('DISCARD'),
        ),
      ],
    );
  }
}
