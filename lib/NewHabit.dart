import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:needy_new/MyScaffold.dart';
import 'package:needy_new/MyHabits.dart';

// import 'package:needy_new/RootPage.dart';
// import 'package:needy_new/authentication.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Add a new habit for the goal: $goalName',
                style: TextStyle(
                  fontFamily: 'Pixelar',
                  fontSize: 28,
                ),
              ),
            ),
            Container(
                height: 500.0,
                width: 600.0,
                child: MyCustomForm(
                    userId: userId, name: name, goalName: goalName)),
          ],
        ),
      ),
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
  double _frequency = 1.0;
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
              'Please enter a habit to continue. You can add more later.',
              style: TextStyle(
                fontFamily: 'Pixelar',
                color: Colors.black,
                fontSize: 24,
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
                fontFamily: 'Pixelar',
                color: Colors.black,
                fontSize: 24,
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
                fontFamily: 'Pixelar',
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.purple[200],
              inactiveTrackColor: Colors.purple[200],
              trackShape: RectangularSliderTrackShape(),
              trackHeight: 4.0,
              thumbColor: Colors.purpleAccent,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
              overlayColor: Colors.purple.withAlpha(32),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
              tickMarkShape: RoundSliderTickMarkShape(),
              activeTickMarkColor: Colors.purple[200],
              inactiveTickMarkColor: Colors.purple[200],
              valueIndicatorShape: PaddleSliderValueIndicatorShape(),
              valueIndicatorTextStyle: TextStyle(
                fontFamily: 'PressStart2P',
                color: Colors.black,
              ),
            ),
            child: Slider(
              min: 0,
              max: 7,
              value: _frequency,
              divisions: 7,
              label: '${_frequency.round()} days',
              onChanged: (value) {
                setState(() {
                  _frequency = value;
                });
              },
            ),
          ),
          (_frequency == 1.0)
              ? Text(
                  'Okay, you will be reminded every day!',
                  style: TextStyle(
                    fontFamily: 'Pixelar',
                    fontSize: 18,
                    color: Colors.grey[800],
                  ),
                )
              : Text(
                  'Okay, you will be reminded every ${_frequency.round()} days!',
                  style: TextStyle(
                    fontFamily: 'Pixelar',
                    fontSize: 18,
                    color: Colors.grey[800],
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RaisedButton(
              color: Colors.pink,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  print(newHabitController);
                  addNewHabit(newHabitController, _frequency);
                  navigateToGoalPage(context);
                }
              },
              child: Text(
                'Next >',
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  color: Colors.yellow,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future navigateToGoalPage(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              MyHabits(userId: userId, name: name, goalName: goalName),
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
        .setData({
      'habitName': habit.text,
      'frequency': frequency,
      'outstanding': false,
      'time': DateTime.now(),
    }).then((res) {
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
