import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:needy_new/MyScaffold.dart';
import 'package:needy_new/NewHabit.dart';
import 'package:needy_new/Summary.dart';

class MyHabits extends StatefulWidget {
  MyHabits({Key key, this.userId, this.name, this.goalName}) : super(key: key);

  final String userId;
  final String name;
  final String goalName;

  @override
  _MyHabits createState() {
    return _MyHabits(userId: userId, name: name, goalName: goalName);
  }
}

class _MyHabits extends State<MyHabits> {
  _MyHabits({this.userId, this.name, this.goalName});

  final String userId;
  final String name;
  final String goalName;

  @override
  Widget build(BuildContext context) {
    print('myhabits: $userId $name $goalName');
    return MyScaffold(
      userId: userId,
      name: name,
      body: Column(
        children: <Widget>[
          Text(goalName),
          Container(
            height: 500.0,
            width: 600.0,
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(userId)
                  .collection('goals')
                  .document(goalName)
                  .collection('habits')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  print('there are no habits here we need to create a ternary');
                  return LinearProgressIndicator();
                }
                // print(Firestore.instance.collection('new_habit').snapshots());
                return _buildHabitList(context, snapshot.data.documents);
              },
            ),
          ),
          RaisedButton(
            textColor: Colors.white,
            color: Colors.pink,
            child: Text(
              'Create a new habit for this goal',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Colors.yellow,
              ),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => NewHabit(
                        userId: userId, name: name, goalName: goalName),
                  ));
            },
          ),
          RaisedButton(
            textColor: Colors.white,
            color: Colors.pink,
            child: Text(
              'Go to Goal summary page',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Colors.yellow,
              ),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Summary(userId: userId, goalName: goalName),
                  ));
            },
          )
        ],
      ),
    );
  }

  Widget _buildHabitList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children:
          snapshot.map((data) => _buildHabitListItem(context, data)).toList(),
    );
  }

  Widget _buildHabitListItem(BuildContext context, DocumentSnapshot data) {
    final habitrecord = HabitRecord.fromSnapshot(data);

    return Padding(
      key: ValueKey(habitrecord.habitName),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.purple),
        child: ListTile(
          title: Text(habitrecord.habitName,
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: (habitrecord.outstanding == true)
                    ? Colors.red
                    : Colors.grey,
              )),
          onTap: () => habitrecord.reference
              .updateData({'outstanding': !habitrecord.outstanding}),
          trailing: Icon(
            (habitrecord.outstanding == true)
                ? Icons.beach_access
                : Icons.check,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}

class HabitRecord {
  final String habitName;
  final bool outstanding;
  // final String frequency; // not using this currently
  final DocumentReference reference;

  HabitRecord.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['habitName'] != null),
        assert(map['outstanding'] != null),
        // assert(map['frequency'] != null),
        habitName = map['habitName'],
        outstanding = map['outstanding'];
  // frequency = map['frequency'];

  HabitRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "HabitRecord<$habitName$outstanding>";
}
