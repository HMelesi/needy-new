import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:needy_new/NewHabit.dart';

class GoalDate extends StatelessWidget {
  GoalDate({Key key, this.goalName, this.userId});
  String goalName;
  String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoalDateForm(goalName: goalName, userId: userId),
      backgroundColor: Colors.purple,
    );
  }
}

class GoalDateForm extends StatefulWidget {
  GoalDateForm({Key key, this.goalName, this.userId});
  String goalName;
  String userId;
  @override
  _GoalDateFormState createState() {
    return _GoalDateFormState(goalName: goalName, userId: userId);
  }
}

class _GoalDateFormState extends State<GoalDateForm> {
  _GoalDateFormState({Key key, this.goalName, this.userId});

  final _formKey = GlobalKey<FormState>();
  final dbRef = Firestore.instance;
  String userId;
  String goalName;
  DateTime _dateTime;
  // double _frequency = 5.0;

  @override
  Widget build(BuildContext context) {
    print(goalName);
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        title: Text(
          'KEEPER',
          style: TextStyle(
            fontFamily: 'PressStart2P',
            color: Colors.yellow,
          ),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Form(
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
            // Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: Text(
            //     'how freqently do you want to be reminded about this goal?',
            //     style: TextStyle(
            //       fontFamily: 'PressStart2P',
            //       color: Colors.cyan,
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Slider.adaptive(
            //     value: _frequency,
            //     onChanged: (newValue) {
            //       setState(() => _frequency = newValue);
            //     },
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: FlatButton(
                onPressed: () {
                  addGoalDate(_dateTime);
                  navigateToHabitPage(context);
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
      ),
    );
  }

  void addGoalDate(date) {
    dbRef
        .collection('users')
        .document(userId)
        .collection('goals')
        .document(goalName)
        .setData({"endDate": date}).then((res) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Date set!'),
        ),
      );
      date.clear();
    }).catchError((err) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(err),
      ));
    });
  }

  Future navigateToHabitPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewHabit()));
  }
}
