import 'package:flutter/material.dart';

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

  // TODO: Add better layout/constraints, handle form submit

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(30.0),
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
            padding: const EdgeInsets.all(30.0),
            child: Text(
              'name the creature',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Colors.cyan,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
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
            padding: const EdgeInsets.all(30.0),
            child: Text(
              'what is your overall goal?',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Colors.cyan,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a goal!';
                }
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
          FlatButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                print('form is valid');
                _formKey.currentState.save();
              }
              print(_petName);
              print(_goalName);
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
        ],
      ),
    );
  }
}
