//Written by Micah Lessnick
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/workout.dart';
import 'dart:math' as math;
import 'package:toast/toast.dart';

class WorkoutList extends StatefulWidget {
  const WorkoutList({Key? key}) : super(key: key);

  @override
  State<WorkoutList> createState() => _WorkoutListState();
}

class _WorkoutListState extends State<WorkoutList>
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

  List<Workout> bottom = <Workout>[];
  List<String> removalList = <String>[];
  //list of workout names to be removed from db
  var dbWorkout;
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final ref = FirebaseDatabase.instance.ref();
    dbInfo() async {
      await ref
          .child('workouts')
          .child(auth.currentUser!.uid.toString())
          .child("Test ID 2")
          .get()
          .then((value) => dbWorkout);
    }

    dbInfo();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(186, 221, 245, 1.0),
      body: SafeArea(
        child: Stack(children: [
          ReorderableListView.builder(
              itemCount: bottom.length,
              itemBuilder: (context, index) {
                final item = bottom[index];
                return Dismissible(
                    key: ValueKey<int>(bottom[index].uid),
                    onDismissed: (direction) {
                      setState(() {
                        //adds the name (key) of removed workout to separate list
                        removalList.add(item.name);
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [Text("Placeholder workout name")],
                                ),
                              ])),
                    ));
              },
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final Workout item = bottom.removeAt(oldIndex);
                  bottom.insert(newIndex, item);
                });
              }),
          Padding(
            //button to update db refs
            padding: const EdgeInsets.only(
                top: 585.0, bottom: 0.0, left: 10.0, right: 0.0),
            child: FloatingActionButton(
              heroTag: "updateDB",
              child: const Icon(
                Icons.upgrade_rounded,
                size: 30.0,
              ),
              elevation: 2.5,
              backgroundColor: const Color(0xFF0CC9C6),
              onPressed: () {
                final FirebaseAuth auth = FirebaseAuth.instance;
                for (var element in removalList) {
                  /*DatabaseReference ref = FirebaseDatabase.instance.ref(
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
                  });*/

                  //set element to null ref in db
                  break;
                }
              },
            ),
          ),
          Padding(
            //button to add an exercise to workout list, sends user to workout page
            padding: EdgeInsets.only(
                top: 585.0,
                bottom: 0.0,
                left: (MediaQuery.of(context).size.width - 70.0),
                right: 0.0),
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
              child: FloatingActionButton(
                heroTag: "addWorkout",
                child: const Icon(Icons.add),
                backgroundColor: const Color(0xFF0CC9C6),
                onPressed: () async {
                  _controller.forward();
                  await Future.delayed(
                      const Duration(milliseconds: 750), () {});
                  //does not properly push to exerciselist page
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ExerciseList()));
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class Workout {
  //workout tuple containing name and unique ID of each workout, similar to exercise object
  String name;
  int uid;

  Workout(this.name, this.uid);
}
