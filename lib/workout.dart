import 'package:flutter/material.dart';

class ExerciseList extends StatefulWidget {
  const ExerciseList({Key? key}) : super(key: key);

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  List<Exercise> bottom = <Exercise>[];

  Future createAlertDialog(BuildContext context) {
    TextEditingController exNameCont = TextEditingController();
    TextEditingController exTypeCont = TextEditingController();

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
                )
              ],
            ),
            actions: [
              MaterialButton(
                elevation: 5.0,
                child: const Text("Submit"),
                onPressed: () {
                  Navigator.of(context).pop(Exercise(exNameCont.text.toString(),
                      exTypeCont.text.toString(), 0, 0, 0));
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise list'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          createAlertDialog(context).then((onValue) {
            Exercise t = onValue;
            setState(() {
              bottom.add(t);
            });
          });
        },
      ),
      body: ReorderableListView.builder(
          itemCount: bottom.length,
          itemBuilder: (context, index) {
            final item = bottom[index];
            return Dismissible(
              //currently does not dismiss
              key: UniqueKey(),
              onDismissed: (direction) {
                // Remove the item from the data source.
                setState(() {
                  bottom.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(item.name + ' dismissed')));
              },
              // Show a red background as the item is swiped away.
              background: Container(color: Colors.red),
              child: ListTile(
                  title: Text("Name: " + item.name + "\nType: " + item.type),
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

  Exercise(this.name, this.type, this.reps, this.sets, this.maxWeight);
}
