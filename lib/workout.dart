import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

    return showDialog(
        context: context,
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
                )
              ],
            ),
            actions: [
              MaterialButton(
                elevation: 5.0,
                child: const Text("Submit"),
                onPressed: () {
                  Navigator.of(context).pop(Exercise(
                      exNameCont.text.toString(),
                      exTypeCont.text.toString(),
                      int.parse(repsCont.text),
                      int.parse(setsCont.text),
                      0,
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
                      item.sets.toString()),
                  trailing: const Icon(Icons.drag_handle)),
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

class Exercise {
  //constructor to act like tuple
  String name;
  String type;
  int reps;
  int sets;
  int maxWeight;
  int uid;

  Exercise(
      this.name, this.type, this.reps, this.sets, this.maxWeight, this.uid);
}
