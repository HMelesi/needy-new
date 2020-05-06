import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:needy_new/NewHabit.dart';

class GoalDate extends StatelessWidget {
  GoalDate({Key key, this.goalName, this.userId, this.petName, this.petType});
  String goalName;
  String userId;
  String petName;
  String petType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoalDateForm(
          goalName: goalName,
          userId: userId,
          petName: petName,
          petType: petType),
      backgroundColor: Colors.green[200],
    );
  }
}

class GoalDateForm extends StatefulWidget {
  GoalDateForm(
      {Key key, this.goalName, this.userId, this.petName, this.petType});
  String goalName;
  String userId;
  String petName;
  String petType;

  @override
  _GoalDateFormState createState() {
    return _GoalDateFormState(
        goalName: goalName, userId: userId, petName: petName, petType: petType);
  }
}

class _GoalDateFormState extends State<GoalDateForm> {
  _GoalDateFormState(
      {Key key, this.goalName, this.userId, this.petName, this.petType});

  final _formKey = GlobalKey<FormState>();
  final dbRef = Firestore.instance;
  String userId;
  String goalName;
  String petName;
  String petType;
  DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
    print(goalName);
    return Scaffold(
      backgroundColor: Colors.green[200],
      appBar: AppBar(
        title: Text(
          'KEEPER',
          style: TextStyle(
            fontFamily: 'PressStart2P',
            color: Colors.yellow,
          ),
        ),
        backgroundColor: Colors.green,
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
                  fontFamily: 'Pixelar',
                  fontSize: 26,
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
                  fontFamily: 'Pixelar',
                  color: Colors.grey[800],
                  fontSize: 18,
                ),
              ),
            ),
            RaisedButton(
              color: Colors.pink,
              child: Text(
                'Pick a date (optional)',
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  color: Colors.yellow,
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
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                color: Colors.pink,
                onPressed: () {
                  addGoalData(_dateTime, petName, petType);
                  navigateToHabitPage(context);
                },
                child: Text(
                  'NEXT',
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    color: Colors.yellow,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addGoalData(date, petName, petType) {
    if (date == null) {
      date = DateTime.now().add(new Duration(days: 20000));
    }
    dbRef
        .collection('users')
        .document(userId)
        .collection('goals')
        .document(goalName)
        .setData({
      "goalName": goalName,
      "endDate": date,
      "petName": petName,
      "petType": petType,
      "petHealth": 10,
      "outstanding": false
    }).then((res) {
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
        context,
        MaterialPageRoute(
            builder: (context) =>
                NewHabit(goalName: goalName, userId: userId)));
  }
}
