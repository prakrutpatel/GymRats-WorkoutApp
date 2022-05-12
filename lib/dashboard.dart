//Written by PK
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:age_calculator/age_calculator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/information_page.dart';
import 'package:flutter_app/runSummary.dart';
import 'package:flutter_app/workout.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toast/toast.dart';
import 'Animation/FadeAnimation.dart';
import 'calendar.dart';
import 'homepage.dart';
import 'workout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Dashboard extends StatefulWidget{
  _Dashboard createState()=> _Dashboard();
}
class _Dashboard extends State<Dashboard>{
  @override
  int _num = 0;
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  String _name = '';
  String _location = '';
  DateTime dob = DateTime(1980, 5, 11);
  String curr_gender = "Male";
  String curr_skill = "Intermediate";



  late File _imageFile;
  String profile_image_url = '';
  static const PickerData2 = '''
[
    [
        1,
        2,
        3,
        4
    ],
    [
        11,
        22,
        33,
        44
    ],
    [
        "aaa",
        "bbb",
        "ccc"
    ]
]
    ''';
  static const genderlist = '''
[ 
    [
        "Male",
        "Female",
        "Others"
    ]
]

    ''';
  static const skilllist = '''
[ 
    [
        "Beginner",
        "Intermediate",
        "Advanced"
    ]
]

    ''';


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
      if (_name == '') {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                Additional_Info_Screen(),
          ),
        );
      }
    });
    dbInfo(path: 'location').then((String result){
      _location = result;
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

    Future<void> _dbpush(String key,String value) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref("users/"+auth.currentUser!.uid);
      await ref.update({
        key: value,
      });
    }

    Future pickImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        _imageFile = File(pickedFile!.path);
      });
      await uploadImageToFirebase(context);
      await networkImage().then((String result){
        profile_image_url = result;
      });
    }
    networkImage().then((String result){
      profile_image_url = result;
    });


    Widget _getWidget(){
      if (_page.toString() == '0') {
        return ListView(
          children: <Widget>[
             FadeAnimation(0.3, SizedBox(
              height: 50.0,
              child: Center(
                child: Text("Today's Workouts", style: GoogleFonts.montserrat(fontSize: 30)),
              ),
            ),
            ),
            FadeAnimation(0.3, SizedBox(height: 75, child: ListView.separated(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (context, _) => const SizedBox(width: 10.0,),
              itemBuilder: (context, index) =>
                  GestureDetector(
                    onTap: () {
                      Toast.show("Starting Workout ${index + 1}", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 200.0,
                        height: 75.0,
                        decoration: const BoxDecoration(
                            color: Colors.white
                        ),
                        child: Center(
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Stack(
                                    children: <Widget>[
                                      Text(
                                        'Workout ${index +
                                            1}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w400),
                                      ),
                                    ]
                                ))),
                      ),
                    ),
                  ),
            ),),),
            FadeAnimation(0.3, SizedBox(
              height: 50.0,
              child: Center(
                child: Text("Run Summary", style: GoogleFonts.montserrat(fontSize: 30)),
              ),
            ),
            ),

            FadeAnimation(0.3, Container(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              height: 300.0,
                child:  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: RunSummary()))),
          ],
        );
      }
      else if (_page.toString() == '1'){
        return const FadeAnimation(0.3, Calendar());
      }
      else if (_page.toString() == '2'){
        return FadeAnimation(0.3, const ExerciseList());
      }
      else {
        return StatefulBuilder(
          builder: (_context, _setState) {
             _pickDateDialog() {
              showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  //which date will display when user open the picker
                  firstDate: DateTime(1950),
                  //what will be the previous supported year in picker
                  lastDate: DateTime
                      .now()) //what will be the up to supported date in picker
                  .then((pickedDate) {
                //then usually do the future job
                if (pickedDate == null) {
                  //if user tap cancel then this function will stop
                  return;
                }
                setState(() {
                  dob = pickedDate;
                });
              });
            }
            return ListView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                FadeAnimation(0.3, SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: 40.0,
                        child: Center(
                          child: Text("Profile", style: GoogleFonts.montserrat(fontSize: 30)),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 20.0,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await pickImage();
                              _setState(() {
                              });
                            },
                            child: Column(
                              children: [
                                CachedNetworkImage(
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
                                  placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                  const CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/images/user_placeholder.png'),
                                  ),
                                  useOldImageOnUrlChange: true,
                                  height: 90,
                                  width: 90,
                                ),
                                Text('change', style: GoogleFonts.montserrat(fontSize: 10, color: Colors.blueGrey),)
                              ],
                            ),
                          ),
                          SizedBox(width: 10.0,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 30.0,
                                width: 230.0,
                                child: TextFormField(
                                  onChanged: (text) async {
                                    if (text == ''){
                                      text = 'Null';
                                    }
                                    await _dbpush('name', text);
                                  },
                                  textAlign: TextAlign.left,
                                  initialValue: _name,
                                  keyboardType: TextInputType.emailAddress,
                                  style: GoogleFonts.montserrat(fontSize: 20),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                height: 30.0,
                                width: 230.0,
                                child: TextFormField(
                                  onChanged: (text) async {
                                    await _dbpush('location', text);
                                  },
                                  textAlign: TextAlign.left,
                                  initialValue: _location,
                                  keyboardType: TextInputType.emailAddress,
                                  style: GoogleFonts.montserrat(fontSize: 20),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'Location',
                                    hintStyle: GoogleFonts.montserrat(fontSize: 20),
                                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        height: 20.0,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 5.0),
                        child: Text(
                          'Personal Information',
                          style: GoogleFonts.montserrat(fontSize: 20,color: Colors.blueGrey.shade800,fontWeight: FontWeight.w400),
                        ),
                      ),
                      Divider(
                        thickness: 1.2,
                        color: Colors.black,
                        endIndent: 2,
                      ),
                      GestureDetector(
                        onTap: () async => print(''),
                        child: Container(
                          //color: Colors.white,
                          height: 40.0,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Birthdate',
                              style: GoogleFonts.montserrat(fontSize: 20),
                                ),
                                Text(
                                  dob.toString().substring(0,10),
                                  style: GoogleFonts.montserrat(fontSize: 13,color: Colors.blueGrey.shade800,fontWeight: FontWeight.w400),
                                ),
                              ],
                            )),
                      ),
                      Divider(
                        thickness: 1.2,
                        color: Colors.black,
                        endIndent: 2,
                      ),
                      Container(
                        //color: Colors.white,
                          height: 40.0,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(left: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Age',
                                style: GoogleFonts.montserrat(fontSize: 20),
                              ),
                              Text(
                                AgeCalculator.age(dob).years.toString(),
                                style: GoogleFonts.montserrat(fontSize: 13,color: Colors.blueGrey.shade800,fontWeight: FontWeight.w400),
                              ),
                            ],
                          )),
                      Divider(
                        thickness: 1.2,
                        color: Colors.black,
                        endIndent: 2,
                      ),
                      GestureDetector(
                        onTap: () async {
                          _pickDateDialog;
                        },
                        child: Container(
                          //color: Colors.white,
                            height: 40.0,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Height',
                                  style: GoogleFonts.montserrat(fontSize: 20),
                                ),
                                Text(
                                  '6-ft 2-in',
                                  style: GoogleFonts.montserrat(fontSize: 13,color: Colors.blueGrey.shade800,fontWeight: FontWeight.w400),
                                ),
                              ],
                            )),
                      ),
                      Divider(
                        thickness: 1.2,
                        color: Colors.black,
                        endIndent: 2,
                      ),
                      GestureDetector(
                        onTap: () async {
                          _pickDateDialog;
                        },
                        child: Container(
                          //color: Colors.white,
                            height: 40.0,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Weight',
                                  style: GoogleFonts.montserrat(fontSize: 20),
                                ),
                                Text(
                                  '185 lbs',
                                  style: GoogleFonts.montserrat(fontSize: 13,color: Colors.blueGrey.shade800,fontWeight: FontWeight.w400),
                                ),
                              ],
                            )),
                      ),
                      Divider(
                        thickness: 1.2,
                        color: Colors.black,
                        endIndent: 2,
                      ),
                      GestureDetector(
                        onTap: () => Picker(
                          height: 75.0,
                            adapter: PickerDataAdapter<String>(
                              pickerdata: JsonDecoder().convert(skilllist),
                              isArray: true,),
                            hideHeader: false,
                            selecteds: [0],
                            selectedTextStyle: TextStyle(color: Colors.blue),
                            onConfirm: (Picker picker, List value) {
                              setState(() {
                                curr_skill = picker.getSelectedValues()[0];
                              });
                              print(value.toString());
                              print(picker.getSelectedValues());
                            }).showDialog(context),
                        child: Container(
                          //color: Colors.white,
                            height: 40.0,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Activity Class',
                                  style: GoogleFonts.montserrat(fontSize: 20),
                                ),
                                Text(
                                  curr_skill,
                                  style: GoogleFonts.montserrat(fontSize: 13,color: Colors.blueGrey.shade800,fontWeight: FontWeight.w400),
                                ),
                              ],
                            )),
                      ),
                      Divider(
                        thickness: 1.2,
                        color: Colors.black,
                        endIndent: 2,
                      ),
                      GestureDetector(
                        onTap: () =>  Picker(
                            adapter: PickerDataAdapter<String>(
                            pickerdata: JsonDecoder().convert(genderlist),
                            isArray: true,),
                            hideHeader: true,
                            selecteds: [0],
                            selectedTextStyle: TextStyle(color: Colors.blue),
                            cancel: TextButton(
                            onPressed: () {
                            Navigator.pop(context);
                            },
                                child: Text('Cancel')),
                                onConfirm: (Picker picker, List value) {
                              setState(() {
                                curr_gender = picker.getSelectedValues()[0];
                              });
                                print(value.toString());
                                print(picker.getSelectedValues());
                            }).showDialog(context),
                        child: Container(
                          //color: Colors.white,
                            height: 40.0,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gender',
                                  style: GoogleFonts.montserrat(fontSize: 20),
                                ),
                                Text(
                                  curr_gender,
                                  style: GoogleFonts.montserrat(fontSize: 13,color: Colors.blueGrey.shade800,fontWeight: FontWeight.w400),
                                ),
                              ],
                            )),
                      ),
                      Divider(
                        thickness: 1.2,
                        color: Colors.black,
                        endIndent: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: 35.0,
                              width: 100.0,
                              child: GestureDetector(
                                onTap: () async {
                                  print('policy');
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    color: Colors.blueGrey,
                                    child: Center(
                                      child: Text(
                                        'Privacy Policy', style: GoogleFonts.montserrat(fontSize: 10,color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 35.0,
                              width: 100.0,
                              child: GestureDetector(
                                onTap: () async {
                                  print('policy');
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    color: Colors.blueGrey,
                                    child: Center(
                                      child: Text(
                                        'Security Policy', style: GoogleFonts.montserrat(fontSize: 10,color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            height: 35.0,
                            width: 100.0,
                            child: GestureDetector(
                              onTap: () async {
                                print('policy');
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  color: Colors.blueGrey,
                                  child: Center(
                                    child: Text(
                                      'Legal', style: GoogleFonts.montserrat(fontSize: 10,color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 35.0,
                            width: 100.0,
                            child: GestureDetector(
                              onTap: () async {
                                print('policy');
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  color: Colors.blueGrey,
                                  child: Center(
                                    child: Text(
                                      'Terms & Conditions', style: GoogleFonts.montserrat(fontSize: 10,color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: SizedBox(
                              height: 40.0,
                              width: 80.0,
                              child: GestureDetector(
                                onTap: () async {
                                  await FirebaseAuth.instance.currentUser?.delete();
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Container(
                                    color: Colors.red,
                                    child: Center(
                                      child: Text(
                                        'Delete', style: TextStyle(color: Colors.white, fontSize: 20.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: FloatingActionButton(
                              child: Icon(Icons.logout_rounded),
                              elevation: 2.5,
                              backgroundColor: const Color(0xFF0CC9C6),
                              onPressed: () {
                                _signOut();
                              },
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
                ),
              ],
            );
          },
        );
      }
    }


    return Scaffold(
      backgroundColor: const Color.fromRGBO(186, 221, 245, 1.0),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 60.0,
          items: const <Widget>[
            Icon(Icons.home_rounded, size: 30),
            Icon(Icons.calendar_view_day_rounded, size: 30),
            Icon(Icons.menu_open_rounded, size: 30),
            Icon(Icons.perm_identity, size: 30),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: const Color.fromRGBO(186, 221, 245, 1.0),
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 500),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          letIndexChange: (index) => true,
        ),
        body: _getWidget()
    );
  }
  Future<void> _signOut() async {
    print(FirebaseAuth.instance.pluginConstants['APP_CURRENT_USER']['providerData'][0]['providerId']);
    if (FirebaseAuth.instance.pluginConstants['APP_CURRENT_USER']['providerData'][0]['providerId'].toString() == 'google.com') {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
    }
    else if (FirebaseAuth.instance.pluginConstants['APP_CURRENT_USER']['providerData'][0]['providerId'].toString() == 'password'){
      await FirebaseAuth.instance.signOut();
    }
  }
}

