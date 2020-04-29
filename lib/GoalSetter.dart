import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoalSetter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoalForm(),
      backgroundColor: Colors.purple,
    );
  }
}

class GoalForm extends StatefulWidget {
  @override
  _GoalFormState createState() {
    return _GoalFormState();
  }
}

class _GoalFormState extends State<GoalForm> {
  String _petName;
  String _goalName;

  final _formKey = GlobalKey<FormState>();
  final newGoalController = TextEditingController();
  final databaseReference = Firestore.instance;

  // TODO: Add better layout/constraints, handle different pets

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'hi james, select the creature you will take care of',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Colors.cyan,
              ),
            ),
          ),
          Container(
            width: 117.0,
            height: 100.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey,
            ),
            child: Image.asset('images/pixil-cat.png'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'name the creature',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Colors.cyan,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a name!';
                }
              },
              onSaved: (String value) {
                _petName = value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                filled: true,
                fillColor: Colors.grey,
                hintText: 'enter a name...',
                hintStyle: TextStyle(
                  fontFamily: 'PressStart2P',
                ),
              ),
              style: TextStyle(
                fontFamily: 'PressStart2P',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'what is your overall goal?',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Colors.cyan,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: newGoalController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a goal!';
                }
                return null;
              },
              onSaved: (String value) {
                _goalName = value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                filled: true,
                fillColor: Colors.grey,
                hintText: 'enter a goal...',
                hintStyle: TextStyle(
                  fontFamily: 'PressStart2P',
                ),
              ),
              style: TextStyle(
                fontFamily: 'PressStart2P',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: FlatButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  print('form is valid');
                  _formKey.currentState.save();
                  addNewGoal(newGoalController);
                }
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

  void addNewGoal(goal) {
    databaseReference
        .collection('welcome')
        .document('test_user')
        .collection('goals')
        .add({'goal': goal.text}).then((res) {
      print(res.documentID);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Goal added!'),
        ),
      );
      goal.clear();
    }).catchError((err) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(err),
        ),
      );
    });
  }
}
