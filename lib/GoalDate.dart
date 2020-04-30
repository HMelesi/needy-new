import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class GoalDate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoalDateForm(),
      backgroundColor: Colors.purple,
    );
  }
}

class GoalDateForm extends StatefulWidget {
  @override
  _GoalDateFormState createState() {
    return _GoalDateFormState();
  }
}

class _GoalDateFormState extends State<GoalDateForm> {
  final _formKey = GlobalKey<FormState>();
  final dbRef = Firestore.instance;

  DateTime _dateTime;
  double _frequency = 5.0;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'when would you like to complete this goal?',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Colors.cyan,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              _dateTime == null
                  ? 'this goal currently has no end date!'
                  : DateFormat.yMMMMEEEEd().format(_dateTime),
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Colors.yellow,
                fontSize: 12,
              ),
            ),
          ),
          FlatButton(
            child: Text(
              'Pick a date (optional)',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Colors.white,
              ),
            ),
            onPressed: () {
              showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2001),
                      lastDate: DateTime(2222))
                  .then((date) {
                setState(() {
                  _dateTime = date;
                });
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'how freqently do you want to be reminded about this goal?',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Colors.cyan,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Slider.adaptive(
              value: _frequency,
              onChanged: (newValue) {
                setState(() => _frequency = newValue);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: FlatButton(
              onPressed: () {
                print('next button pressed');
              },
              child: Text(
                'NEXT',
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
