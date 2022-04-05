//Written by Micah Lessnick
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class ExerciseList extends StatefulWidget {
  const ExerciseList({Key? key}) : super(key: key);

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
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

  List<Exercise> bottom = <Exercise>[];
  int _counter = 0;
  Future createAlertDialog(BuildContext context) {
    TextEditingController exNameCont = TextEditingController();
    TextEditingController exTypeCont = TextEditingController();
    TextEditingController repsCont = TextEditingController();
    TextEditingController setsCont = TextEditingController();
    TextEditingController timeCont = TextEditingController();

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("Enter Exercise:"),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: exNameCont,
                  decoration: const InputDecoration(hintText: 'Exercise name'),
                ),
                TextField(
                  controller: exTypeCont,
                  decoration: const InputDecoration(hintText: 'Exercise type'),
                ),
                TextField(
                  controller: repsCont,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(hintText: "reps"),
                ),
                TextField(
                  controller: setsCont,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(hintText: "sets"),
                ),
                TextFormField(
                  controller: timeCont,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                  decoration: const InputDecoration(
                    hintText: '00:00:00',
                  ),
                  inputFormatters: <TextInputFormatter>[
                    TimeTextInputFormatter() // This input formatter will do the job
                  ],
                )
              ],
            ),
            actions: [
              MaterialButton(
                elevation: 5.0,
                child: const Text("Submit"),
                onPressed: () {
                  int durInSec = 0; //duration in seconds
                  String durTemp = timeCont.text;
                  List<String> splitDur = timeCont.text
                      .toString()
                      .split(':'); //time segments stored into array
                  durInSec += (int.parse(splitDur[0]) * 3600) +
                      (int.parse(splitDur[1]) * 60) +
                      (int.parse(splitDur[
                          2])); //convert array into actual time (in seconds)
                  Navigator.of(context).pop(Exercise(
                      exNameCont.text.toString(),
                      exTypeCont.text.toString(),
                      int.parse(repsCont.text),
                      int.parse(setsCont.text),
                      0,
                      durInSec,
                      durTemp,
                      _counter));
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(186, 221, 245, 1.0),
      appBar: null,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          createAlertDialog(context).then((onValue) {
            Exercise t = onValue;
            setState(() {
              bottom.add(t);
              _counter += 1;
            });
          });
        },
      ),
      body: ReorderableListView.builder(
          itemCount: bottom.length,
          itemBuilder: (context, index) {
            final item = bottom[index];
            return Dismissible(
              key: ValueKey<int>(bottom[index].uid),
              onDismissed: (direction) {
                setState(() {
                  bottom.removeAt(bottom.indexOf(item));
                });
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(item.name + ' dismissed')));
              },
              // Show a red background as the item is swiped away.
              background: Container(color: Colors.red),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                    tileColor: const Color.fromRGBO(143, 148, 251, 1),
                    textColor: const Color.fromRGBO(255, 255, 255, 1),
                    title: Text("Name: " +
                        item.name +
                        "\nType: " +
                        item.type +
                        "\nReps: " +
                        item.reps.toString() +
                        "\nSets: " +
                        item.sets.toString() +
                        "\nDuration: " +
                        item.durDisp),
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
  int reps;
  int sets;
  int maxWeight;
  int dur;
  String durDisp; //allows real time to be stored and formatted to be displayed
  int uid;

  Exercise(this.name, this.type, this.reps, this.sets, this.maxWeight, this.dur,
      this.durDisp, this.uid);
}
