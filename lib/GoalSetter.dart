import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:needy_new/GoalDate.dart';

class GoalSetter extends StatelessWidget {
  GoalSetter({Key key, this.userId, this.name});

  final String userId;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoalForm(userId: userId, name: name),
      backgroundColor: Colors.purple,
    );
  }
}

class GoalForm extends StatefulWidget {
  GoalForm({Key key, this.userId, this.name});

  final String userId;
  final String name;

  @override
  _GoalFormState createState() {
    return _GoalFormState(userId: userId, name: name);
  }
}

class _GoalFormState extends State<GoalForm> {
  _GoalFormState({Key key, this.userId, this.name});

  final String userId;
  final String name;
  String _petName;
  String goalName;

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
              'hi $name, select the creature you will take care of',
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
                goalName = value;
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
                  _formKey.currentState.save();
                  addNewGoal(newGoalController);
                  navigateToDatePage(context);
                  print(goalName);
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

  Future navigateToDatePage(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                GoalDate(goalName: goalName, userId: userId)));
  }

  void addNewGoal(goal) {
    databaseReference
        .collection('users')
        .document(userId)
        .collection('goals')
        .document(goal.text)
        .setData({'goal': goal.text}).then((res) {
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
