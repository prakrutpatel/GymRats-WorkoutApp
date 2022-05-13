// Written by Mark Yamane
library event_calendar;

import 'dart:math';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app/exercise-editor.dart';
import 'package:flutter_app/workout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

part 'color-picker.dart';

part 'timezone-picker.dart';

part 'appointment-editor.dart';

//ignore: must_be_immutable
class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  CalendarState createState() => CalendarState();
}

List<Color> _colorCollection = <Color>[]; // available color objects
List<String> _colorNames = <String>[]; // available color names
int _selectedColorIndex = 0; // default color
int _selectedTimeZoneIndex = 0; // default timezone
List<String> _timeZoneCollection = <String>[]; // available time zones
late DataSource _events; // workouts displayed on calendar
Appointment? _selectedAppointment;
DateTime _selectedDate = DateTime(
    DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
late DateTime _startDate;
late TimeOfDay _startTime;
late DateTime _endDate;
late TimeOfDay _endTime;
bool _isAllDay = false;
String _subject = '';
String _notes = '';

class CalendarState extends State<Calendar> {
  CalendarState();

  CalendarView _calendarView = CalendarView.month;
  late List<String> eventNameCollection;
  late List<Appointment> appointments;

  @override
  void initState() {
    _calendarView = CalendarView.month;
    appointments = getAppointmentDetails();
    _events = DataSource(appointments);
    _selectedAppointment = null;
    _selectedColorIndex = 0;
    _selectedTimeZoneIndex = 0;
    _subject = '';
    _notes = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(186, 221, 245, 1.0),
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF0CC9C6),
          onPressed: () {
            addNewWorkout();
          },
          child: const Icon(Icons.add),
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: getCalendar(_calendarView, _events, onCalendarTapped)));
  }

  void selectionChanged(CalendarSelectionDetails details) {
    _selectedDate = details.date!;
  }

  SfCalendar getCalendar(
      CalendarView _calendarView,
      CalendarDataSource _calendarDataSource,
      CalendarTapCallback calendarTapCallback) {
    return SfCalendar(
        // general calendar settings
        view: _calendarView,
        dataSource: _calendarDataSource,
        onSelectionChanged: selectionChanged,
        onTap: calendarTapCallback,
        initialDisplayDate: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 0, 0, 0),
        initialSelectedDate: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 0, 0, 0),
        todayHighlightColor: const Color(0xFF0CC9C6),
        allowedViews: <CalendarView>[
          CalendarView.month,
          CalendarView.schedule,
        ],
        monthViewSettings: MonthViewSettings(
          showAgenda: true,
          agendaViewHeight: MediaQuery.of(context).size.height / 3,
        ),
        timeSlotViewSettings: TimeSlotViewSettings(
            minimumAppointmentDuration: const Duration(minutes: 60)));
  }

  void onCalendarViewChange(String value) {
    if (value == 'Day') {
      _calendarView = CalendarView.day;
    } else if (value == 'Week') {
      _calendarView = CalendarView.week;
    } else if (value == 'Work week') {
      _calendarView = CalendarView.workWeek;
    } else if (value == 'Month') {
      _calendarView = CalendarView.month;
    } else if (value == 'Timeline day') {
      _calendarView = CalendarView.timelineDay;
    } else if (value == 'Timeline week') {
      _calendarView = CalendarView.timelineWeek;
    } else if (value == 'Timeline work week') {
      _calendarView = CalendarView.timelineWorkWeek;
    }

    setState(() {});
  }

  void addNewWorkout() {
    // add new workout appointment
    setState(() {
      _selectedAppointment = null;
      _isAllDay = false;
      _selectedColorIndex = 0;
      _selectedTimeZoneIndex = 0;
      _subject = '';
      _notes = '';

      final DateTime date = _selectedDate;
      _startDate = date;
      _endDate = date.add(const Duration(hours: 1));

      _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
      _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);

      Navigator.push<Widget>(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => AppointmentEditor()),
      );
    });
  }

  void onCalendarTapped(CalendarTapDetails details) {
    // only change workout times if a pre-made appointment is selected
    if (details.targetElement != CalendarElement.calendarCell &&
        details.targetElement != CalendarElement.appointment) {
      return;
    }

    setState(() {
      _selectedAppointment = null;
      _isAllDay = false;
      _selectedColorIndex = 0;
      _selectedTimeZoneIndex = 0;
      _subject = '';
      _notes = '';
      if (details.appointments != null && details.appointments!.length == 1) {
        final Appointment AppointmentDetails = details.appointments![0];
        _startDate = AppointmentDetails.from;
        _endDate = AppointmentDetails.to;
        _isAllDay = AppointmentDetails.isAllDay;
        _selectedColorIndex =
            _colorCollection.indexOf(AppointmentDetails.background);
        _selectedTimeZoneIndex = AppointmentDetails.startTimeZone == ''
            ? 0
            : _timeZoneCollection.indexOf(AppointmentDetails.startTimeZone);
        _subject = AppointmentDetails.eventName == '(No title)'
            ? ''
            : AppointmentDetails.eventName;
        _notes = AppointmentDetails.description;
        _selectedAppointment = AppointmentDetails;
        _startTime =
            TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
        _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
        Navigator.push<Widget>(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  ExerciseEditor(name: _subject)),
        );
      }
    });
  }

  List<Appointment> getAppointmentDetails() {
    final List<Appointment> AppointmentCollection = <Appointment>[];
    eventNameCollection = <String>[];
    eventNameCollection.add('Weightlifting');
    eventNameCollection.add('Cardio');
    eventNameCollection.add('Long Distance Cardio');

    _colorCollection = <Color>[];
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF85461E));
    _colorCollection.add(const Color(0xFFFF00FF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));

    _colorNames = <String>[];
    _colorNames.add('Green');
    _colorNames.add('Purple');
    _colorNames.add('Red');
    _colorNames.add('Orange');
    _colorNames.add('Caramel');
    _colorNames.add('Magenta');
    _colorNames.add('Blue');
    _colorNames.add('Peach');
    _colorNames.add('Gray');

    _timeZoneCollection = <String>[];
    _timeZoneCollection.add('Default Time');
    _timeZoneCollection.add('Alaskan Standard Time');
    _timeZoneCollection.add('Hawaiian Standard Time');
    _timeZoneCollection.add('Pacific Standard Time');
    _timeZoneCollection.add('Pacific Standard Time (Mexico)');
    _timeZoneCollection.add('US Eastern Standard Time');
    _timeZoneCollection.add('US Mountain Standard Time');

    /*
    final FirebaseAuth auth = FirebaseAuth.instance;
    final querySnap = FirebaseDatabase.instance
        .ref('calendars/' + auth.currentUser!.uid + "/")
        .get();
    Map<dynamic, dynamic> values = querySnap;

    List<dynamic> key = parsedData.key.toList();
    print(parsedData.toString());
    print(key.toString());
    
    if (parsedData != null) {
      for (int i = 0; i < key.length; i++) {
        data = values[key[i]];
        collection ??= <Meeting>[];
        final Random random = new Random();
        collection.add(Meeting(
            eventName: data['Subject'],
            isAllDay: false,
            from: DateFormat('dd/MM/yyyy HH:mm:ss').parse(data['StartTime']),
            to: DateFormat('dd/MM/yyyy HH:mm:ss').parse(data['EndTime']),
            background: _colorCollection[random.nextInt(9)],
            resourceId: data['ResourceId']));
      }
    } */
    final DateTime today = DateTime.now();
    final Random random = Random();
    for (int month = -1; month < 2; month++) {
      for (int day = -5; day < 5; day++) {
        for (int hour = 9; hour < 18; hour += 5) {
          AppointmentCollection.add(Appointment(
            from: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: hour)),
            to: today
                .add(Duration(days: (month * 30) + day))
                .add(Duration(hours: hour + 1)),
            background: _colorCollection[random.nextInt(9)],
            startTimeZone: '',
            endTimeZone: '',
            description: '',
            isAllDay: false,
            eventName: eventNameCollection[random.nextInt(3)],
          ));
        }
      }
    }

    return AppointmentCollection;
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }

  @override
  bool isAllDay(int index) => appointments![index].isAllDay;

  @override
  String getSubject(int index) => appointments![index].eventName;

  @override
  String getStartTimeZone(int index) => appointments![index].startTimeZone;

  @override
  String getNotes(int index) => appointments![index].description;

  @override
  String getEndTimeZone(int index) => appointments![index].endTimeZone;

  @override
  Color getColor(int index) => appointments![index].background;

  @override
  DateTime getStartTime(int index) => appointments![index].from;

  @override
  DateTime getEndTime(int index) => appointments![index].to;
}

class Appointment {
  Appointment(
      {required this.from,
      required this.to,
      this.background = Colors.green,
      this.isAllDay = false,
      this.eventName = '',
      this.startTimeZone = '',
      this.endTimeZone = '',
      this.description = ''});

  final String eventName;
  final DateTime from;
  final DateTime to;
  final Color background;
  final bool isAllDay;
  final String startTimeZone;
  final String endTimeZone;
  final String description;
}
