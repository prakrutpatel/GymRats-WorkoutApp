//Written by PK
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/Animation/FadeAnimation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/Tutorial/onboarding_screen.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:firebase_database/firebase_database.dart';


class Additional_Info_Screen extends StatefulWidget{
  Info createState()=> Info();
}
class Info extends State<Additional_Info_Screen> {
  @override
  var _fullname = TextEditingController();
  var _age = TextEditingController();
  var _weight = TextEditingController();
  var _height = TextEditingController();
  var _gender = TextEditingController();
  var _skill_level = TextEditingController();
  String dropdownValuegender = 'Male';
  String dropdownValueskill = 'Beginner';


  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    Future<void> _dbpush() async {
      DatabaseReference ref = FirebaseDatabase.instance.ref("users/"+auth.currentUser!.uid);
      await ref.set({
        "name": _fullname.text,
        "age": _age.text,
        "weight": _weight.text,
        "height": _height.text,
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
                  height: 400,
                  decoration: BoxDecoration(
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
                          decoration: BoxDecoration(
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
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/light-2.png')
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
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/clock.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        child: FadeAnimation(1.6, Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text("Additional Information", style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold),),
                          ),
                        )),
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
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(
                                      color: Colors.grey.shade100))
                              ),
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
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(
                                      color: Colors.grey.shade100))
                              ),
                              child: TextFormField(
                                controller: _age,
                                keyboardType: TextInputType.number,
                                autocorrect: false,
                                autovalidateMode: AutovalidateMode
                                    .onUserInteraction,
                                validator: Validators.compose([
                                  Validators.required('Age is required'),
                                ]),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Age",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _weight,
                                keyboardType: TextInputType.number,
                                autovalidateMode: AutovalidateMode
                                    .onUserInteraction,
                                validator: Validators.compose([
                                  Validators.required('Weight is required'),
                                ]),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Weight",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _height,
                                keyboardType: TextInputType.number,
                                autovalidateMode: AutovalidateMode
                                    .onUserInteraction,
                                validator: Validators.compose([
                                  Validators.required('Height is required'),
                                ]),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Height",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                                child: DropdownButton<String>(
                                  value: dropdownValuegender,
                                  isExpanded: true,
                                  elevation: 16,
                                  underline: Container(
                                    height: 2,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValuegender = newValue!;
                                    });
                                  },
                                  items: <String>['Male','Female']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  hint:Text(
                                    "Please choose a gender",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: DropdownButton<String>(
                              value: dropdownValueskill,
                              isExpanded: true,
                              elevation: 16,
                              underline: Container(
                                height: 2,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValueskill = newValue!;
                                });
                              },
                              items: <String>['Beginner','Intermediate','Advanced']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                                hint:Text(
                                  "Please choose a skill level",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                ),
                            ),
                            )
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
                                        Color.fromRGBO(143, 148, 251, 1),
                                        Color.fromRGBO(143, 148, 251, .6),
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