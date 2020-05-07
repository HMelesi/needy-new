import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:needy_new/MarqueeWidget.dart';
import 'package:needy_new/MyScaffold.dart';
import 'package:needy_new/NewHabit.dart';
import 'package:needy_new/Summary.dart';
import 'package:intl/intl.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';

class MyHabits extends StatefulWidget {
  MyHabits({Key key, this.userId, this.name, this.goalName, this.endDate})
      : super(key: key);

  final String userId;
  final String name;
  final String goalName;
  final Timestamp endDate;

  @override
  _MyHabits createState() {
    return _MyHabits(
        userId: userId, name: name, goalName: goalName, endDate: endDate);
  }
}

class _MyHabits extends State<MyHabits> {
  _MyHabits({this.userId, this.name, this.goalName, this.endDate});

  final String userId;
  final String name;
  final String goalName;
  final Timestamp endDate;

  @override
  Widget build(BuildContext context) {
    print('myhabits: $userId $name $goalName');
    return MyScaffold(
      userId: userId,
      name: name,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: MarqueeWidget(
              direction: Axis.horizontal,
              child: Text(
                goalName,
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  fontSize: 24,
                ),
              ),
            ),
          ),
          Text(
            'This goal will end on ${DateFormat.yMMMMEEEEd().format(endDate.toDate())}',
            style: TextStyle(
              fontFamily: 'Pixelar',
              fontSize: 18,
              color: Colors.grey[800],
            ),
          ),
          RaisedButton(
            textColor: Colors.white,
            color: Colors.pink,
            child: Text(
              'Create a new habit',
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
              'View summary',
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
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(userId)
                  .collection('goals')
                  .document(goalName)
                  .collection('habits')
                  .orderBy('outstanding', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  print('there are no habits here we need to create a ternary');
                  return LinearProgressIndicator();
                }
                return _buildHabitList(context, snapshot.data.documents);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    final _controller = ScrollController();
    return FadingEdgeScrollView.fromScrollView(
      child: ListView(
        controller: _controller,
        padding: const EdgeInsets.only(top: 20.0),
        children:
            snapshot.map((data) => _buildHabitListItem(context, data)).toList(),
      ),
    );
  }

  Widget _buildHabitListItem(BuildContext context, DocumentSnapshot data) {
    final habitrecord = HabitRecord.fromSnapshot(data);

    return Padding(
      key: ValueKey(habitrecord.habitName),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.green[300]),
        child: ListTile(
          title: Text(
            habitrecord.habitName,
            style: TextStyle(
              fontFamily: 'Pixelar',
              fontSize: 28,
              color: (habitrecord.outstanding == true)
                  ? Colors.red
                  : Colors.grey[800],
            ),
          ),
          onTap: (habitrecord.outstanding == true)
              ? () => habitrecord.reference.updateData({
                    'outstanding': !habitrecord.outstanding,
                    'time': DateTime.now()
                  })
              : null,
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
