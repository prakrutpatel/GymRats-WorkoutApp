import 'package:flutter/material.dart';

void main() => runApp(const WorkoutTest());

class WorkoutTest extends StatelessWidget {
  const WorkoutTest({Key? key}) : super(key: key);

  static const String _title = 'Workout List';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: ExerciseList(),
    );
  }
}

class ExerciseList extends StatefulWidget {
  const ExerciseList({Key? key}) : super(key: key);

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  List<Exercise> bottom = <Exercise>[];

  Future createAlertDialog(BuildContext context) {
    TextEditingController exNameCont = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Enter Exercise:"),
            content: TextField(
              controller: exNameCont,
            ),
            actions: [
              MaterialButton(
                elevation: 5.0,
                child: const Text("Submit"),
                onPressed: () {
                  Navigator.of(context).pop(exNameCont.text.toString());
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
            Exercise t = Exercise(onValue, "[empty]", 0, 0, 0);
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
              key: Key('$index'),
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
