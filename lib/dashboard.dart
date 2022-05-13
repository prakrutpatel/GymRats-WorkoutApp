//Written by PK
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
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
  String curr_weight = "180";
  String curr_weight_scale = "lbs";
  String curr_height_feet = "6";
  String curr_height_inches = "2";



  late File _imageFile;
  String profile_image_url = '';
  static const heightlist = '''
[ 
    [
        4,
        5,
        6,
        7,
        8
    ],
    [
        "'"
    ],
    [
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11
    ],
    [
        "''"
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
  static const weightlist = '''
[ 
    [
        30,
        31,
        32,
        33,
        34,
        35,
        36,
        37,
        38,
        39,
        40,
        41,
        42,
        43,
        44,
        45,
        46,
        47,
        48,
        49,
        50,
        51,
        52,
        53,
        54,
        55,
        56,
        57,
        58,
        59,
        60,
        61,
        62,
        63,
        64,
        65,
        66,
        67,
        68,
        69,
        70,
        71,
        72,
        73,
        74,
        75,
        76,
        77,
        78,
        79,
        80,
        81,
        82,
        83,
        84,
        85,
        86,
        87,
        88,
        89,
        90,
        91,
        92,
        93,
        94,
        95,
        96,
        97,
        98,
        99,
        100,
        101,
        102,
        103,
        104,
        105,
        106,
        107,
        108,
        109,
        110,
        111,
        112,
        113,
        114,
        115,
        116,
        117,
        118,
        119,
        120,
        121,
        122,
        123,
        124,
        125,
        126,
        127,
        128,
        129,
        130,
        131,
        132,
        133,
        134,
        135,
        136,
        137,
        138,
        139,
        140,
        141,
        142,
        143,
        144,
        145,
        146,
        147,
        148,
        149,
        150,
        151,
        152,
        153,
        154,
        155,
        156,
        157,
        158,
        159,
        160,
        161,
        162,
        163,
        164,
        165,
        166,
        167,
        168,
        169,
        170,
        171,
        172,
        173,
        174,
        175,
        176,
        177,
        178,
        179,
        180,
        181,
        182,
        183,
        184,
        185,
        186,
        187,
        188,
        189,
        190,
        191,
        192,
        193,
        194,
        195,
        196,
        197,
        198,
        199,
        200,
        201,
        202,
        203,
        204,
        205,
        206,
        207,
        208,
        209,
        210,
        211,
        212,
        213,
        214,
        215,
        216,
        217,
        218,
        219,
        220,
        221,
        222,
        223,
        224,
        225,
        226,
        227,
        228,
        229,
        230,
        231,
        232,
        233,
        234,
        235,
        236,
        237,
        238,
        239,
        240,
        241,
        242,
        243,
        244,
        245,
        246,
        247,
        248,
        249,
        250,
        251,
        252,
        253,
        254,
        255,
        256,
        257,
        258,
        259,
        260,
        261,
        262,
        263,
        264,
        265,
        266,
        267,
        268,
        269,
        270,
        271,
        272,
        273,
        274,
        275,
        276,
        277,
        278,
        279,
        280,
        281,
        282,
        283,
        284,
        285,
        286,
        287,
        288,
        289,
        290,
        291,
        292,
        293,
        294,
        295,
        296,
        297,
        298,
        299,
        300,
        301,
        302,
        303,
        304,
        305,
        306,
        307,
        308,
        309,
        310,
        311,
        312,
        313,
        314,
        315,
        316,
        317,
        318,
        319,
        320,
        321,
        322,
        323,
        324,
        325,
        326,
        327,
        328,
        329,
        330,
        331,
        332,
        333,
        334,
        335,
        336,
        337,
        338,
        339,
        340,
        341,
        342,
        343,
        344,
        345,
        346,
        347,
        348,
        349
    ],
    [
        "lbs",
        "kgs"
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

  var weight = [30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349];
  var weight_scale = ["lbs","kgs"];
  var skill = ["Beginner","Intermediate","Advanced"];
  var gender = ["Male","Female","Others"];
  var height = [4,5,6,7,8];
  var height_scale = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

  Widget build(BuildContext context) {
    final devheight = MediaQuery.of(context).size.height;
    final devwidth = MediaQuery.of(context).size.width;
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
    dbInfo(path: 'gender').then((String result){
      curr_gender = result;
    });
    dbInfo(path: 'dob').then((String result){
      dob = DateTime.parse(result);
    });
    dbInfo(path: 'skill level').then((String result){
      curr_skill = result;
    });
    dbInfo(path: 'location').then((String result){
      _location = result;
    });
    dbInfo(path: 'weight').then((String result){
      curr_weight = result;
    });
    dbInfo(path: 'weight scale').then((String result){
      curr_weight_scale = result;
    });
    dbInfo(path: 'height').then((String result){
      curr_height_feet = result;
    });
    dbInfo(path: 'height inches').then((String result){
      curr_height_inches = result;
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
        }
      } catch (err){
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
    double getheight(double val){
      return (val/771)*devheight;
    }
    double getwidth(double val){
      return (val/360.0)*devwidth;
    }


    Widget _getWidget(){
      if (_page.toString() == '0') {
        return ListView(
          children: <Widget>[
             FadeAnimation(0.3, SizedBox(
              height: getheight(50.0),
              child: Center(
                child: Text("Today's Workouts", style: GoogleFonts.montserrat(fontSize: 30)),
              ),
            ),
            ),
            FadeAnimation(0.3, SizedBox(height: getheight(75), child: ListView.separated(
              padding: EdgeInsets.only(left: getwidth(15.0), right: getwidth(15.0)),
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (context, _) => SizedBox(width: getwidth(10.0)),
              itemBuilder: (context, index) =>
                  GestureDetector(
                    onTap: () {
                      Toast.show("Starting Workout ${index + 1}", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: getheight(200.0),
                        height: getwidth(75.0),
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
              height: getheight(50.0),
              child: Center(
                child: Text("Run Summary", style: GoogleFonts.montserrat(fontSize: 30)),
              ),
            ),
            ),

            FadeAnimation(0.3, Container(
              padding: EdgeInsets.only(left: getwidth(10.0), right: getwidth(10.0)),
              height: getheight(300.0),
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
            return ListView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                FadeAnimation(0.3, SizedBox(
                  child: Padding(
                    padding: EdgeInsets.only(top: getheight(16.0)),
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: getheight(30.0),
                        child: Center(
                          child: Text("Profile", style: GoogleFonts.montserrat(fontSize: getheight(30))),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: getwidth(20.0),
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
                                  height: getwidth(90).floorToDouble(),
                                  width: getwidth(90).floorToDouble(),
                                ),
                                Text('change', style: GoogleFonts.montserrat(fontSize: getheight(10).floorToDouble(), color: Colors.blueGrey),)
                              ],
                            ),
                          ),
                          SizedBox(width: getwidth(10.0),),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: getheight(30.0).floorToDouble(),
                                width: getwidth(230.0),
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
                                  style: GoogleFonts.montserrat(fontSize: getheight(20.0).floorToDouble()),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: getheight(5.0).floorToDouble(),
                              ),
                              Container(
                                height: getheight(30.0).floorToDouble(),
                                width: getwidth(230.0),
                                child: TextFormField(
                                  onChanged: (text) async {
                                    await _dbpush('location', text);
                                  },
                                  textAlign: TextAlign.left,
                                  initialValue: _location,
                                  keyboardType: TextInputType.emailAddress,
                                  style: GoogleFonts.montserrat(fontSize: getheight(20.0).floorToDouble()),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'Location',
                                    hintStyle: GoogleFonts.montserrat(fontSize: getheight(20.0).floorToDouble()),
                                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: getheight(10.0).floorToDouble(),
                      ),
                      Container(
                        height: getheight(20.0).floorToDouble(),
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: getwidth(5.0)),
                        child: Text(
                          'Personal Information',
                          style: GoogleFonts.montserrat(fontSize: getheight(20).floorToDouble(),color: Colors.blueGrey.shade800,fontWeight: FontWeight.w400),
                        ),
                      ),
                      Divider(
                        height: getheight(16.0).floorToDouble(),
                        thickness: getheight(1.2),
                        color: Colors.black,
                        endIndent: getwidth(2.0),
                      ),
                      GestureDetector(
                        onTap: () => showDatePicker(
                            context: context,
                            initialDate: dob,
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
                          setState(() async {
                            await _dbpush('dob', pickedDate.toString());
                            dob = pickedDate;
                          });
                        }),
                        child: Container(
                          //color: Colors.white,
                          height: getheight(40.0).floorToDouble(),
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: getwidth(5.0)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Birthdate',
                              style: GoogleFonts.montserrat(fontSize: getheight(20).floorToDouble()),
                                ),
                                Text(
                                  dob.month.toString()+'-'+dob.day.toString()+'-'+dob.year.toString(),
                                  style: GoogleFonts.montserrat(fontSize: getheight(13).floorToDouble(),color: Colors.blueGrey.shade800,fontWeight: FontWeight.w400),
                                ),
                              ],
                            )),
                      ),
                      Divider(
                        height: getheight(16.0).floorToDouble(),
                        thickness: getheight(1.2),
                        color: Colors.black,
                        endIndent: getwidth(2.0),
                      ),
                      Container(
                        //color: Colors.white,
                          height: getheight(40.0).floorToDouble(),
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(left: getwidth(5.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Age',
                                style: GoogleFonts.montserrat(fontSize: getheight(20).floorToDouble()),
                              ),
                              Text(
                                AgeCalculator.age(dob).years.toString(),
                                style: GoogleFonts.montserrat(fontSize: getheight(13).floorToDouble(),color: Colors.blueGrey.shade800,fontWeight: FontWeight.w400),
                              ),
                            ],
                          )),
                      Divider(
                        height: getheight(16.0).floorToDouble(),
                        thickness: getheight(1.2),
                        color: Colors.black,
                        endIndent: getwidth(2.0),
                      ),
                      GestureDetector(
                        onTap: () => Picker(
                            height: getheight(60.0),
                            adapter: PickerDataAdapter<String>(
                              pickerdata: JsonDecoder().convert(heightlist),
                              isArray: true,),
                            hideHeader: true,
                            selecteds: [height.indexOf(int.parse(curr_height_feet)),0,height_scale.indexOf(int.parse(curr_height_inches)),0],
                            selectedTextStyle: TextStyle(color: Colors.blue),
                            onConfirm: (Picker picker, List value) async {
                              await _dbpush('height', picker.getSelectedValues()[0]);
                              await _dbpush('height inches', picker.getSelectedValues()[2]);
                              setState(() {
                                curr_height_feet = picker.getSelectedValues()[0];
                                curr_height_inches = picker.getSelectedValues()[2];
                              });
                            }).showDialog(context),
                        child: Container(
                          //color: Colors.white,
                            height: getheight(40.0).floorToDouble(),
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: getwidth(5.0)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Height',
                                  style: GoogleFonts.montserrat(fontSize: getheight(20).floorToDouble()),
                                ),
                                Text(
                                  curr_height_feet+"'"+" "+curr_height_inches+"''",
                                  style: GoogleFonts.montserrat(fontSize: getheight(13).floorToDouble(),color: Colors.blueGrey.shade800,fontWeight: FontWeight.w400),
                                ),
                              ],
                            )),
                      ),
                      Divider(
                        height: getheight(16.0).floorToDouble(),
                        thickness: getheight(1.2),
                        color: Colors.black,
                        endIndent: getwidth(2.0),
                      ),
                      GestureDetector(
                        onTap: () => Picker(
                            height: getheight(50.0),
                            adapter: PickerDataAdapter<String>(
                              pickerdata: JsonDecoder().convert(weightlist),
                              isArray: true,),
                            hideHeader: true,
                            selecteds: [weight.indexOf(int.parse(curr_weight)),weight_scale.indexOf(curr_weight_scale)],
                            selectedTextStyle: TextStyle(color: Colors.blue),
                            onConfirm: (Picker picker, List value) async {
                              await _dbpush('weight', picker.getSelectedValues()[0]);
                              await _dbpush('weight scale', picker.getSelectedValues()[1]);
                              setState(() {
                                curr_weight = picker.getSelectedValues()[0];
                                curr_weight_scale = picker.getSelectedValues()[1];
                              });
                            }).showDialog(context),
                        child: Container(
                          //color: Colors.white,
                            height: getheight(40.0).floorToDouble(),
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: getwidth(5.0)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Weight',
                                  style: GoogleFonts.montserrat(fontSize: getheight(20).floorToDouble()),
                                ),
                                Text(
                                  curr_weight+' '+curr_weight_scale,
                                  style: GoogleFonts.montserrat(fontSize: getheight(13).floorToDouble(),color: Colors.blueGrey.shade800,fontWeight: FontWeight.w400),
                                ),
                              ],
                            )),
                      ),
                      Divider(
                        height: getheight(16.0).floorToDouble(),
                        thickness: getheight(1.2),
                        color: Colors.black,
                        endIndent: getwidth(2.0),
                      ),
                      GestureDetector(
                        onTap: () => Picker(
                          height: getheight(50.0),
                            adapter: PickerDataAdapter<String>(
                              pickerdata: JsonDecoder().convert(skilllist),
                              isArray: true,),
                            hideHeader: true,
                            selecteds: [skill.indexOf(curr_skill)],
                            selectedTextStyle: TextStyle(color: Colors.blue),
                            onConfirm: (Picker picker, List value) async {
                              await _dbpush('skill level', picker.getSelectedValues()[0]);
                              setState(() {
                                curr_skill = picker.getSelectedValues()[0];
                              });
                            }).showDialog(context),
                        child: Container(
                            height: getheight(40.0).floorToDouble(),
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: getwidth(5.0)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Activity Class',
                                  style: GoogleFonts.montserrat(fontSize: getheight(20).floorToDouble()),
                                ),
                                Text(
                                  curr_skill,
                                  style: GoogleFonts.montserrat(fontSize: getheight(13).floorToDouble(),color: Colors.blueGrey.shade800,fontWeight: FontWeight.w400),
                                ),
                              ],
                            )),
                      ),
                      Divider(
                        height: getheight(16.0).floorToDouble(),
                        thickness: getheight(1.2),
                        color: Colors.black,
                        endIndent: getwidth(2.0),
                      ),
                      GestureDetector(
                        onTap: () =>  Picker(
                          height: getheight(50.0),
                            adapter: PickerDataAdapter<String>(
                            pickerdata: JsonDecoder().convert(genderlist),
                            isArray: true,),
                            hideHeader: true,
                            selecteds: [gender.indexOf(curr_gender)],
                            selectedTextStyle: TextStyle(color: Colors.blue),
                            cancel: TextButton(
                            onPressed: () {
                            Navigator.pop(context);
                            },
                                child: Text('Cancel')),
                                onConfirm: (Picker picker, List value) async {
                                  await _dbpush('gender', picker.getSelectedValues()[0]);
                              setState(() {
                                curr_gender = picker.getSelectedValues()[0];
                              });
                            }).showDialog(context),
                        child: Container(
                          //color: Colors.white,
                            height: getheight(40.0).floorToDouble(),
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: getwidth(5.0)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gender',
                                  style: GoogleFonts.montserrat(fontSize: getheight(20).floorToDouble()),
                                ),
                                Text(
                                  curr_gender,
                                  style: GoogleFonts.montserrat(fontSize: getheight(13).floorToDouble(),color: Colors.blueGrey.shade800,fontWeight: FontWeight.w400),
                                ),
                              ],
                            )),
                      ),
                      Divider(
                        height: getheight(16.0).floorToDouble(),
                        thickness: getheight(1.2),
                        color: Colors.black,
                        endIndent: getwidth(2.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: getheight(5.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: getheight(35.0).floorToDouble(),
                              width: getwidth(100.0),
                              child: GestureDetector(
                                onTap: () async {
                                  Navigator.pushReplacement<void, void>(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          Additional_Info_Screen(),
                                    ),
                                  );
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
                              height: getheight(35.0).floorToDouble(),
                              width: getwidth(100.0),
                              child: GestureDetector(
                                onTap: () async {
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
                            height: getheight(35.0).floorToDouble(),
                            width: getwidth(100.0),
                            child: GestureDetector(
                              onTap: () async {
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
                            height: getheight(35.0).floorToDouble(),
                            width: getwidth(100.0),
                            child: GestureDetector(
                              onTap: () async {
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
                        height: getheight(30.0).floorToDouble(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: getwidth(15.0)),
                            child: SizedBox(
                              height: getheight(30.0).floorToDouble(),
                              width: getwidth(80.0),
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
                                        'Delete Account', style: TextStyle(color: Colors.white, fontSize: getheight(10.0).floorToDouble()),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: getwidth(15.0)),
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
          height: getheight(60.0),
          items: <Widget>[
            Icon(Icons.home_rounded, size: getwidth(30.0)),
            Icon(Icons.calendar_view_day_rounded, size: getwidth(30.0)),
            Icon(Icons.menu_open_rounded, size: getwidth(30.0)),
            Icon(Icons.perm_identity, size: getwidth(30.0)),
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
    if (FirebaseAuth.instance.pluginConstants['APP_CURRENT_USER']['providerData'][0]['providerId'].toString() == 'google.com') {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
    }
    else if (FirebaseAuth.instance.pluginConstants['APP_CURRENT_USER']['providerData'][0]['providerId'].toString() == 'password'){
      await FirebaseAuth.instance.signOut();
    }
  }
}

