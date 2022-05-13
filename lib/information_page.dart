//Written by PK
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Animation/FadeAnimation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/Tutorial/onboarding_screen.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:firebase_database/firebase_database.dart';


class Additional_Info_Screen extends StatefulWidget{
  Info createState()=> Info();
}
class Info extends State<Additional_Info_Screen> {
  @override
  var _fullname = TextEditingController();
  var _dob = TextEditingController();
  var _weight = TextEditingController();
  var _weight_scale = TextEditingController();
  var _height = TextEditingController();
  var _height_scale = TextEditingController();
  var _gender = TextEditingController();
  var _skill_level = TextEditingController();
  String dropdownValuegender = 'Male';
  String dropdownValueskill = 'Beginner';
  String defaultweight = 'Weight';
  String defaultheight = 'Height';
  String defaultgender = 'Gender';
  String defaultskill = 'Skill Level';
  String defaultdob = 'Date of Birth';
  String defaultname = 'Name';

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
  static const genderlist = '''
[ 
    [
        "Male",
        "Female",
        "Others"
    ]
]

    ''';
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
  static const skilllist = '''
[ 
    [
        "Beginner",
        "Intermediate",
        "Advanced"
    ]
]

    ''';
  final FirebaseAuth auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref();
  Future<String> dbInfo({required String path}) async {
    final snapshot = await ref.child('users/'+ auth.currentUser!.uid+"/"+path).get();
    if (snapshot.exists) {
      return snapshot.value.toString();
    } else {
      return "";
    }
  }

  void initState() {
    dbInfo(path: 'name').then((String result){
      _fullname.text = result;
      defaultname = result;
      setState(() {

      });
    });
    dbInfo(path: 'gender').then((String result){
      _gender.text = result;
      if (result != ''){
        defaultgender = result;
      }
      setState(() {

      });
    });
    dbInfo(path: 'dob').then((String result){
      _dob.text = result;
      defaultdob = DateTime.parse(result).month.toString()+'-'+DateTime.parse(result).day.toString()+'-'+DateTime.parse(result).year.toString();
      setState(() {

      });
    });
    dbInfo(path: 'skill level').then((String result){
      _skill_level.text = result;
      if (result != ''){
        defaultskill = result;
      }
      setState(() {

      });
    });
    dbInfo(path: 'weight').then((String result){
      _weight.text = result;
      setState(() {
      });
    });
    dbInfo(path: 'weight scale').then((String result){
      _weight_scale.text = result;
      setState(() {

      });
    });
    dbInfo(path: 'height').then((String result){
      _height.text = result;
      setState(() {

      });
    });
    dbInfo(path: 'height inches').then((String result){
      _height_scale.text = result;
      setState(() {

      });
    });

  }





  Widget build(BuildContext context) {
    if (_weight.text != "" && _weight_scale.text != ""){
      defaultweight = _weight.text+' '+_weight_scale.text;
    }
    if (_height.text != "" && _height_scale.text != ""){
      defaultheight = _height.text+"'"+" "+_height_scale.text+"''";
    }
    final devheight = MediaQuery.of(context).size.height;
    final devwidth = MediaQuery.of(context).size.width;
    double getheight(double val){
      return (val/770.6)*devheight;
    }
    double getwidth(double val){
      return (val/360.0)*devwidth;
    }

    Future<void> _dbpush() async {
      DatabaseReference ref = FirebaseDatabase.instance.ref("users/"+auth.currentUser!.uid);
      await ref.set({
        "name": _fullname.text,
        "dob": _dob.text,
        "weight": _weight.text,
        "weight scale": _weight_scale.text,
        "height": _height.text,
        "height inches": _height_scale.text,
        "gender": _gender.text,
        "skill level": _skill_level.text,
      });
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const OnboardingScreen(),
        ),
      );
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
                          child: Text("Personal Information",textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontSize: 50,color: Colors.white),),
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
                              height: 40.0,
                              padding: EdgeInsets.only(left: 5.0, top: 10.0),
                              child: TextFormField(
                                controller: _fullname,
                                keyboardType: TextInputType.emailAddress,
                                autovalidateMode: AutovalidateMode
                                    .onUserInteraction,
                                validator: Validators.compose([
                                  Validators.required('Name is required'),
                                ]),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Name",
                                  hintStyle: TextStyle(color: Colors.grey.shade400),
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey.shade600,
                            ),
                            GestureDetector(
                              onTap: () => showDatePicker(
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
                              _dob.text = pickedDate.toString();
                            defaultdob = pickedDate.month.toString()+'-'+pickedDate.day.toString()+'-'+pickedDate.year.toString();
                            });
                            }),
                              child: Container(
                                //color: Colors.lightBlue,
                                  height: 40.0,
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(left: 5.0,top: 10.0),
                                  child: Text(
                                    defaultdob,
                                    style: GoogleFonts.montserrat(fontSize: 15,color: Colors.grey.shade400),
                                    textAlign: TextAlign.left,
                                  )),
                            ),
                            Divider(
                              color: Colors.grey.shade600,
                            ),
                            GestureDetector(
                              onTap: () => Picker(
                                  height: 50.0,
                                  adapter: PickerDataAdapter<String>(
                                    pickerdata: JsonDecoder().convert(weightlist),
                                    isArray: true,),
                                  hideHeader: true,
                                  selecteds: [0,0],
                                  selectedTextStyle: TextStyle(color: Colors.blue),
                                  onConfirm: (Picker picker, List value) async {
                                    setState(() {
                                      defaultweight = picker.getSelectedValues()[0]+' '+picker.getSelectedValues()[1];
                                      _weight.text = picker.getSelectedValues()[0];
                                      _weight_scale.text = picker.getSelectedValues()[1];
                                    });
                                  }).showDialog(context),
                              child: Container(
                                //color: Colors.lightBlue,
                                  height: 40.0,
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(left: 5.0,top: 10.0),
                                  child: Text(
                                    defaultweight,
                                    style: GoogleFonts.montserrat(fontSize: 15,color: Colors.grey.shade400),
                                    textAlign: TextAlign.left,
                                  )),
                            ),
                            Divider(
                              color: Colors.grey.shade600,
                            ),
                            GestureDetector(
                              onTap: () => Picker(
                                  height: 50.0,
                                  adapter: PickerDataAdapter<String>(
                                    pickerdata: JsonDecoder().convert(heightlist),
                                    isArray: true,),
                                  hideHeader: true,
                                  selecteds: [0,0,0,0],
                                  selectedTextStyle: TextStyle(color: Colors.blue),
                                  onConfirm: (Picker picker, List value) async {
                                    setState(() {
                                      defaultheight = picker.getSelectedValues()[0]+"'"+" "+picker.getSelectedValues()[2]+"''";
                                      _height.text = picker.getSelectedValues()[0];
                                      _height_scale.text = picker.getSelectedValues()[2];
                                    });
                                  }).showDialog(context),
                              child: Container(
                                //color: Colors.lightBlue,
                                  height: 40.0,
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(left: 5.0,top: 10.0),
                                  child: Text(
                                    defaultheight,
                                    style: GoogleFonts.montserrat(fontSize: 15,color: Colors.grey.shade400),
                                    textAlign: TextAlign.left,
                                  )),
                            ),
                            Divider(
                              color: Colors.grey.shade600,
                            ),
                            GestureDetector(
                              onTap: () => Picker(
                                  height: 50.0,
                                  adapter: PickerDataAdapter<String>(
                                    pickerdata: JsonDecoder().convert(genderlist),
                                    isArray: true,),
                                  hideHeader: true,
                                  selecteds: [0],
                                  selectedTextStyle: TextStyle(color: Colors.blue),
                                  onConfirm: (Picker picker, List value) async {
                                    setState(() {
                                      defaultgender = picker.getSelectedValues()[0];
                                      _gender.text = picker.getSelectedValues()[0];
                                    });
                                  }).showDialog(context),
                              child: Container(
                                //color: Colors.lightBlue,
                                  height: 40.0,
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(left: 5.0,top: 10.0),
                                  child: Text(
                                    defaultgender,
                                    style: GoogleFonts.montserrat(fontSize: 15,color: Colors.grey.shade400),
                                    textAlign: TextAlign.left,
                                  )),
                            ),
                            Divider(
                              color: Colors.grey.shade600,
                            ),
                            GestureDetector(
                              onTap: () => Picker(
                                  height: 50.0,
                                  adapter: PickerDataAdapter<String>(
                                    pickerdata: JsonDecoder().convert(skilllist),
                                    isArray: true,),
                                  hideHeader: true,
                                  selecteds: [0],
                                  selectedTextStyle: TextStyle(color: Colors.blue),
                                  onConfirm: (Picker picker, List value) async {
                                    setState(() {
                                      defaultskill = picker.getSelectedValues()[0];
                                      _skill_level.text = picker.getSelectedValues()[0];
                                    });
                                  }).showDialog(context),
                              child: Container(
                                //color: Colors.lightBlue,
                                  height: 40.0,
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(left: 5.0,top: 10.0),
                                  child: Text(
                                    defaultskill,
                                    style: GoogleFonts.montserrat(fontSize: 15,color: Colors.grey.shade400),
                                    textAlign: TextAlign.left,
                                  )),
                            ),
                          ],
                        ),
                      )
                      ),
                      SizedBox(height: 20,),
                      FadeAnimation(2,
                          GestureDetector(
                            onTap: () async {
                              _dbpush();
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
                                child: Text("Continue", style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),),
                              ),
                            ),
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