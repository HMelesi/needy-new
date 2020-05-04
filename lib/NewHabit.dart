import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:needy_new/MyScaffold.dart';
import 'package:needy_new/RootPage.dart';
import 'package:needy_new/authentication.dart';

class NewHabit extends StatelessWidget {
  NewHabit({Key key, this.userId, this.name, this.goalName});

  final String userId;
  final String name;
  final String goalName;

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      userId: userId,
      name: name,
      body: MyCustomForm(userId: userId, name: name, goalName: goalName),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  MyCustomForm({Key key, this.userId, this.name, this.goalName});

  final String userId;
  final String name;
  final String goalName;
  @override
  MyCustomFormState createState() {
    return MyCustomFormState(userId: userId, name: name, goalName: goalName);
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  MyCustomFormState({this.userId, this.name, this.goalName});

  final String userId;
  final String name;
  final String goalName;
  double _frequency = 5.0;
  final _formKey = GlobalKey<FormState>();
  final newHabitController = TextEditingController();
  final dbRef = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    print('newhabit: $userId $name');
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'New Habit',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Colors.black,
                fontSize: 25.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Please enter a habit to continue. You can add more later.',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: newHabitController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                filled: true,
                fillColor: Colors.grey,
                hintText: 'enter habit...',
              ),
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Colors.black,
                fontSize: 16.0,
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a habit';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'How often would you like to be reminded about this habit?',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.cyan[700],
              inactiveTrackColor: Colors.cyan[100],
              trackShape: RectangularSliderTrackShape(),
              trackHeight: 4.0,
              thumbColor: Colors.cyanAccent,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
              overlayColor: Colors.cyan.withAlpha(32),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
              tickMarkShape: RoundSliderTickMarkShape(),
              activeTickMarkColor: Colors.cyan[700],
              inactiveTickMarkColor: Colors.cyan[100],
              valueIndicatorShape: PaddleSliderValueIndicatorShape(),
              valueIndicatorTextStyle: TextStyle(
                fontFamily: 'PressStart2P',
                color: Colors.black,
              ),
            ),
            child: Slider(
              min: 0,
              max: 10,
              value: _frequency,
              divisions: 10,
              label: '$_frequency',
              onChanged: (value) {
                setState(() {
                  _frequency = value;
                });
              },
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: FlatButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  print(newHabitController);
                  addNewHabit(newHabitController, _frequency);
                  navigateToWelcomePage(context);
                }
              },
              child: Text(
                'Next >',
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future navigateToWelcomePage(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              RootPage(userId: userId, name: name, auth: Auth()),
        ));
  }

  void addNewHabit(habit, frequency) {
    print(goalName);
    dbRef
        .collection('users')
        .document(userId)
        .collection('goals')
        .document(goalName)
        .collection('habits')
        .document(habit.text)
        .setData({'habit': habit.text, 'frequency': frequency}).then((res) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Habit Added!'),
        ),
      );
      habit.clear();
    }).catchError((err) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(err),
        ),
      );
    });
  }
}
