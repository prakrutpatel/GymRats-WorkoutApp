import 'package:flutter/material.dart';
import 'package:cardio_tracker_vid/db/db.dart';
import 'package:cardio_tracker_vid/model/entry.dart';
import 'package:cardio_tracker_vid/pages/maps.dart';
import 'package:cardio_tracker_vid/widgets/entry_card.dart';

class RunSummary extends StatefulWidget {
  const RunSummary({Key? key}) : super(key: key);

  @override
  _RunSummaryState createState() => _RunSummaryState();
}

class _RunSummaryState extends State<RunSummary> {
  late List<Entry> _data;
  List<EntryCard> _cards = [];

  void initState() {
    super.initState();
    DB.init().then((value) => _fetchEntries());
  }

  void _fetchEntries() async {
    _cards = [];
    List<Map<String, dynamic>> _results = await DB.query(Entry.table);
    _data = _results.map((item) => Entry.fromMap(item)).toList();
    _data.forEach((element) => _cards.add(EntryCard(entry: element)));
    setState(() {});
  }

  void _addEntries(Entry en) async {
    DB.insert(Entry.table, en);
    _fetchEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Runs"),
      ),
      body: ListView(
        children: _cards,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => MapPage()))
            .then((value) => _addEntries(value)),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}