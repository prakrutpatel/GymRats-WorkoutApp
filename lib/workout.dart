//Written by Micah Lessnick
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:toast/toast.dart';

class ExerciseList extends StatefulWidget {
  const ExerciseList({Key? key}) : super(key: key);

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool typing = false;
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String dropVal = "Weightlifting";
  List<Exercise> bottom = <Exercise>[];
  int _counter = 0;
  //workout type flags
  bool _wlSelect = true;
  bool _cardioSelect = false;
  bool _longDistSelect = false;
  Future createAlertDialog(BuildContext context) {
    TextEditingController exNameCont = TextEditingController();
    TextEditingController comp1Cont =
        TextEditingController(); //reps, distance based on workout type
    TextEditingController comp2Cont =
        TextEditingController(); //sets, based on workout type
    TextEditingController comp3Cont =
        TextEditingController(); //weight, based on workout type
    TextEditingController timeCont = TextEditingController();
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text("Enter Exercise:"),
              scrollable: true,
              content: Column(
                children: <Widget>[
                  TextField(
                    controller: exNameCont,
                    decoration:
                        const InputDecoration(hintText: 'Exercise name'),
                  ),
                  DropdownButtonFormField(
                      //create dropdown that lets user select a given workout type
                      value: dropVal,
                      isExpanded: true,
                      elevation: 16,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropVal = newValue!;
                          _wlSelect = identical(dropVal, "Weightlifting");
                          _cardioSelect = identical(dropVal, "Cardio");
                          _longDistSelect =
                              identical(dropVal, "Long-distance run");
                        });
                      },
                      onSaved: (value) {
                        setState(() {
                          dropVal = value!.toString();
                          _wlSelect = identical(dropVal, "Weightlifting");
                          _cardioSelect = identical(dropVal, "Cardio");
                          _longDistSelect =
                              identical(dropVal, "Long-distance run");
                        });
                      },
                      items: <String>[
                        'Weightlifting',
                        'Cardio',
                        'Long-distance run'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: const Text(
                        "Please choose an exercise type",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w500),
                      )),
                  Visibility(
                    //weightlifting type chosen, display necessary parts in popup
                    visible: _wlSelect,
                    child: Column(
                      children: [
                        TextField(
                          controller: comp1Cont,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(hintText: "reps"),
                        ),
                        TextField(
                          controller: comp2Cont,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(hintText: "sets"),
                        ),
                        TextField(
                          controller: comp3Cont,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration:
                              const InputDecoration(hintText: "Max weight"),
                        ),
                        TextFormField(
                          controller: timeCont,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false),
                          decoration: const InputDecoration(
                            hintText: '00:00:00',
                          ),
                          inputFormatters: <TextInputFormatter>[
                            TimeTextInputFormatter() // This input formatter will do the job
                          ],
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    //cardio type chosen, display necessary parts in popup
                    visible: _cardioSelect,
                    child: Column(
                      children: [
                        TextField(
                          controller: comp1Cont,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                              hintText: "distance (miles)"),
                        ),
                        TextFormField(
                          controller: timeCont,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false),
                          decoration: const InputDecoration(
                            hintText: '00:00:00',
                          ),
                          inputFormatters: <TextInputFormatter>[
                            TimeTextInputFormatter() // This input formatter will do the job
                          ],
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    //long-distance run chosen, display necessary parts in popup
                    visible: _longDistSelect,
                    child: Column(
                      children: [
                        TextField(
                          controller: comp1Cont,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                              hintText: "distance (miles)"),
                        ),
                        TextFormField(
                          controller: timeCont,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false),
                          decoration: const InputDecoration(
                            hintText: '00:00:00',
                          ),
                          inputFormatters: <TextInputFormatter>[
                            TimeTextInputFormatter() // This input formatter will do the job
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                MaterialButton(
                  elevation: 5.0,
                  child: const Text("Submit"),
                  onPressed: () async {
                    //setting and overriding default cases
                    String nameTemp = "";
                    if (exNameCont.text.isNotEmpty) {
                      nameTemp = exNameCont.text.toString();
                    }
                    String typeTemp = dropVal;

                    int comp1Temp = 0;
                    if (comp1Cont.text.isNotEmpty) {
                      comp1Temp = int.parse(comp1Cont.text);
                    }
                    int comp2Temp = 0;
                    if (comp2Cont.text.isNotEmpty) {
                      comp2Temp = int.parse(comp2Cont.text);
                    }
                    int comp3Temp = 0;
                    if (comp3Cont.text.isNotEmpty) {
                      comp3Temp = int.parse(comp3Cont.text);
                    }
                    int durInSec = 0; //duration in seconds
                    String timeTemp = "00:00:00";
                    if ((timeCont.text.isNotEmpty) &&
                        (timeCont.text != "00:00:00")) {
                      timeTemp = timeCont.text;
                    }

                    String durTemp = timeTemp;
                    List<String> splitDur =
                        timeTemp.split(':'); //time segments stored into array
                    durInSec += (int.parse(splitDur[0]) * 3600) +
                        (int.parse(splitDur[1]) * 60) +
                        (int.parse(splitDur[
                            2])); //convert array into actual time (in seconds)
                    Navigator.of(context).pop(Exercise(
                        nameTemp,
                        typeTemp,
                        comp1Temp,
                        comp2Temp,
                        comp3Temp,
                        durInSec,
                        durTemp,
                        _counter));
                    _controller.reverse();
                    await Future.delayed(
                        const Duration(milliseconds: 750), () {});
                  },
                )
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController workoutname = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(186, 221, 245, 1.0),
        elevation: 0.0,
        title: Container(
          height: 40.0,
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Center(
            child: TextFormField(
              textAlign: TextAlign.center,
              controller: workoutname,
              style: const TextStyle(
                color: Color.fromRGBO(150, 206, 243, 1.0),
                fontSize: 27,
                fontWeight: FontWeight.w400,
              ),
              decoration: const InputDecoration.collapsed(
                hintText: 'Untitled Workout',
                hintStyle: TextStyle(
                  color: Color.fromRGBO(150, 206, 243, 1.0),
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(186, 221, 245, 1.0),
      body: SafeArea(
        child: Stack(children: [
          ReorderableListView.builder(
              itemCount: bottom.length,
              itemBuilder: (context, index) {
                final item = bottom[index];
                return Dismissible(
                  //remove element that was swiped away, used uid as index can shift (reordering)
                  key: ValueKey<int>(bottom[index].uid),
                  onDismissed: (direction) {
                    setState(() {
                      bottom.removeAt(bottom.indexOf(item));
                    });
                    Toast.show(item.name + ' dismissed', context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  },
                  // Show a red background as the item is swiped away.
                  background: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(color: Colors.red),
                    ),
                  ),
                  child: Padding(
                    //display individual exercise element
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        tileColor: const Color.fromRGBO(141, 192, 228, 1.0),
                        textColor: const Color.fromRGBO(255, 255, 255, 1),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Name: " + item.name),
                                Text("Type: " + item.type)
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (bottom[index].type == "Weightlifting") ...[
                                  //workout type is weightlifting
                                  Text("Reps: " + item.comp1.toString()),
                                  Text("Sets: " + item.comp2.toString())
                                ] else if (bottom[index].type == "Cardio") ...[
                                  //workout type is cardio
                                  Text("Distance: " +
                                      item.comp1.toString() +
                                      " miles")
                                ] else ...[
                                  //workout type is long-dist run
                                  Text("Distance: " +
                                      item.comp1.toString() +
                                      " miles")
                                ]
                              ],
                            ),
                            Text("Duration: " + item.durDisp),
                          ],
                        ),
                        trailing: const Icon(Icons.drag_handle)),
                  ),
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final Exercise item = bottom.removeAt(oldIndex);
                  bottom.insert(newIndex, item);
                });
              }),
          Padding(
            padding: const EdgeInsets.only(
                top: 585.0, bottom: 0.0, left: 10.0, right: 0.0),
            child: FloatingActionButton(
              child: const Icon(
                Icons.upgrade_rounded,
                size: 30.0,
              ),
              elevation: 2.5,
              backgroundColor: const Color(0xFF0CC9C6),
              onPressed: () {
                final FirebaseAuth auth = FirebaseAuth.instance;
                for (var element in bottom) {
                  DatabaseReference ref = FirebaseDatabase.instance.ref(
                      "workouts/" +
                          auth.currentUser!.uid +
                          "/${workoutname.text}/" +
                          element.name);
                  ref.set({
                    "name": element.name,
                    "type": element.type,
                    "comp1": element.comp1,
                    "comp2": element.comp2,
                    "duration": element.durDisp,
                    "max weight": element.comp3,
                  });
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 585.0,
                bottom: 0.0,
                left: (MediaQuery.of(context).size.width - 70.0),
                right: 0.0),
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                backgroundColor: const Color(0xFF0CC9C6),
                onPressed: () async {
                  _controller.forward();
                  await Future.delayed(
                      const Duration(milliseconds: 750), () {});
                  createAlertDialog(context).then((onValue) {
                    Exercise t = onValue;
                    setState(() {
                      bottom.add(t);
                      _counter += 1;
                    });
                  });
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class TimeTextInputFormatter extends TextInputFormatter {
  //input formatter for making a time field input
  RegExp _exp = RegExp(r'^[0-9:]+$');
  TimeTextInputFormatter() {
    _exp = RegExp(r'^[0-9:]+$');
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_exp.hasMatch(newValue.text)) {
      TextSelection newSelection = newValue.selection;

      String value = newValue.text;
      String newText;

      String leftChunk = '';
      String rightChunk = '';
      //parse entered string, add/remove leading 0s as needed based on user input
      if (value.length >= 8) {
        if (value.substring(0, 7) == '00:00:0') {
          leftChunk = '00:00:';
          rightChunk = value.substring(leftChunk.length + 1, value.length);
        } else if (value.substring(0, 6) == '00:00:') {
          leftChunk = '00:0';
          rightChunk = value.substring(6, 7) + ":" + value.substring(7);
        } else if (value.substring(0, 4) == '00:0') {
          leftChunk = '00:';
          rightChunk = value.substring(4, 5) +
              value.substring(6, 7) +
              ":" +
              value.substring(7);
        } else if (value.substring(0, 3) == '00:') {
          leftChunk = '0';
          rightChunk = value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7) +
              ":" +
              value.substring(7, 8) +
              value.substring(8);
        } else {
          leftChunk = '';
          rightChunk = value.substring(1, 2) +
              value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7) +
              ":" +
              value.substring(7);
        }
      } else if (value.length == 7) {
        if (value.substring(0, 7) == '00:00:0') {
          leftChunk = '';
          rightChunk = '';
        } else if (value.substring(0, 6) == '00:00:') {
          leftChunk = '00:00:0';
          rightChunk = value.substring(6, 7);
        } else if (value.substring(0, 1) == '0') {
          leftChunk = '00:';
          rightChunk = value.substring(1, 2) +
              value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7);
        } else {
          leftChunk = '';
          rightChunk = value.substring(1, 2) +
              value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7) +
              ":" +
              value.substring(7);
        }
      } else {
        leftChunk = '00:00:0';
        rightChunk = value;
      }

      if (oldValue.text.isNotEmpty && oldValue.text.substring(0, 1) != '0') {
        if (value.length > 7) {
          return oldValue;
        } else {
          leftChunk = '0';
          rightChunk = value.substring(0, 1) +
              ":" +
              value.substring(1, 2) +
              value.substring(3, 4) +
              ":" +
              value.substring(4, 5) +
              value.substring(6, 7);
        }
      }

      newText = leftChunk + rightChunk;

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(newText.length, newText.length),
        extentOffset: math.min(newText.length, newText.length),
      );

      return TextEditingValue(
        text: newText,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return oldValue;
  }
}

class Exercise {
  //constructor to act like tuple
  String name;
  String type;
  int comp1;
  int comp2;
  int comp3;
  int dur;
  String durDisp; //allows real time to be stored and formatted to be displayed
  int uid;

  Exercise(this.name, this.type, this.comp1, this.comp2, this.comp3, this.dur,
      this.durDisp, this.uid);
}

class TextBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.white,
      child: TextField(
        decoration:
            InputDecoration(border: InputBorder.none, hintText: 'Search'),
      ),
    );
  }
}
