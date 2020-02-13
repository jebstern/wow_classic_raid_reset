import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WoW:C RR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'WoW Classic Raid reset'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final oneSec = const Duration(seconds: 1);
  Timer _timerOnyxiaEu;
  Timer _timerOnyxiaUs;
  Timer _timerMcEu;
  Timer _timerMcUs;
  int _timerValueOnyxiaEu = 100;
  int _timerValueOnyxiaUs = 100;
  int _timerValueMcEu = 100;
  int _timerValueMcUs = 100;
  String _resetLabelOnyxiaEu = '';
  String _resetLabelOnyxiaUs = '';
  String _resetLabelMcEu = '';
  String _resetLabelMcUs = '';

  @override
  void initState() {
    super.initState();
    _startTimerOnyxiaEu();
    _startTimerOnyxiaUs();
    _starTimerMcEu();
    _starTimerMcUs();
  }

  @override
  void dispose() {
    _timerOnyxiaEu.cancel();
    _timerOnyxiaUs.cancel();
    _timerMcEu.cancel();
    _timerMcUs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "EU",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            Text(
              'Onyxia',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _resetLabelOnyxiaEu,
            ),
            Text(
              _resetTimestamp(dayOfWeek: 4, hourOfDay: 9),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Molten Core',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              _resetLabelMcEu,
            ),
            Text(
              _resetTimestamp(dayOfWeek: 3, hourOfDay: 9),
            ),
            Divider(
              height: 42,
            ),
            Text(
              "US",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            Text(
              'Onyxia',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              _resetLabelOnyxiaUs,
            ),
            Text(
              _resetTimestamp(dayOfWeek: 2, hourOfDay: 18),
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              'Molten Core',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              _resetLabelMcUs,
            ),
            Text(
              _resetTimestamp(dayOfWeek: 2, hourOfDay: 18),
            ),
          ],
        ),
      ),
    );
  }

  String _resetTimestamp({int hourOfDay = 9, int dayOfWeek = 4}) {
    return DateFormat('EEE dd.MM.yyyy kk:mm')
        .format(_resetDateTime(dayOfWeek: dayOfWeek, hourOfDay: hourOfDay));
  }

  DateTime _resetDateTime({int hourOfDay = 9, int dayOfWeek = 4}) {
    DateTime now = DateTime.now().toLocal();
    DateTime resetTime =
        DateTime(now.year, now.month, now.day, hourOfDay).toLocal();
    if (resetTime.weekday < dayOfWeek) {
      return resetTime.add(Duration(days: dayOfWeek - resetTime.weekday));
    } else if (resetTime.weekday == dayOfWeek) {
      if (now.isBefore(resetTime)) {
        return resetTime;
      } else {
        return resetTime.add(Duration(days: 7));
      }
    } else {
      return resetTime
          .subtract(Duration(days: resetTime.weekday - dayOfWeek))
          .add(Duration(days: 7));
    }
  }

  int _timeInSeconds({int hourOfDay = 9, int dayOfWeek = 4}) {
    DateTime resetDateTime =
        _resetDateTime(hourOfDay: hourOfDay, dayOfWeek: dayOfWeek);
    double seconds = (resetDateTime.millisecondsSinceEpoch -
            DateTime.now().toLocal().millisecondsSinceEpoch) /
        1000;
    return seconds.round();
  }

  String _countdownTime({int hourOfDay = 9, int dayOfWeek = 4}) {
    int seconds = _timeInSeconds(dayOfWeek: dayOfWeek, hourOfDay: hourOfDay);
    int days = seconds ~/ 60 ~/ 60 ~/ 24;
    int hours = (seconds ~/ 60 ~/ 60) - days * 24;
    int minutes = seconds ~/ 60 - hours * 60 - (days * 24 * 60);
    int second = seconds % 60;
    return '${days}d ${hours}h ${minutes}m ${second}s';
  }

  void _startTimerOnyxiaEu() {
    _timerValueOnyxiaEu = _timeInSeconds(hourOfDay: 9, dayOfWeek: 4);
    _timerOnyxiaEu = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_timerValueOnyxiaEu < 1) {
            timer.cancel();
            _timerValueOnyxiaEu = 100;
            _resetLabelOnyxiaEu = 'Instance resetted!';
          } else {
            _resetLabelOnyxiaEu = _countdownTime(dayOfWeek: 4, hourOfDay: 9);
            _timerValueOnyxiaEu = _timerValueOnyxiaEu - 1;
          }
        },
      ),
    );
  }

  void _startTimerOnyxiaUs() {
    _timerValueOnyxiaUs = _timeInSeconds(dayOfWeek: 5, hourOfDay: 18);
    _timerOnyxiaUs = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_timerValueOnyxiaUs < 1) {
            timer.cancel();
            _timerValueOnyxiaUs = 100;
            _resetLabelOnyxiaUs = 'Instance resetted!';
          } else {
            _resetLabelOnyxiaUs = _countdownTime(dayOfWeek: 5, hourOfDay: 18);
            _timerValueOnyxiaUs = _timerValueOnyxiaUs - 1;
          }
        },
      ),
    );
  }

  void _starTimerMcEu() {
    _timerValueMcEu = _timeInSeconds(hourOfDay: 9, dayOfWeek: 3);
    _timerMcEu = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_timerValueMcEu < 1) {
            timer.cancel();
            _timerValueMcEu = 100;
            _resetLabelMcEu = 'Instance resetted!';
          } else {
            _resetLabelMcEu = _countdownTime(dayOfWeek: 3, hourOfDay: 9);
            _timerValueMcEu = _timerValueMcEu - 1;
          }
        },
      ),
    );
  }

  void _starTimerMcUs() {
    _timerValueMcUs = _timeInSeconds(dayOfWeek: 2, hourOfDay: 18);
    _timerMcUs = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_timerValueMcUs < 1) {
            timer.cancel();
            _timerValueMcUs = 100;
            _resetLabelMcUs = 'Instance resetted!';
          } else {
            _resetLabelMcUs = _countdownTime(dayOfWeek: 2, hourOfDay: 18);
            _timerValueMcUs = _timerValueMcUs - 1;
          }
        },
      ),
    );
  }
}
