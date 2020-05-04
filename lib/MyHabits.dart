import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:needy_new/MyScaffold.dart';

class MyHabits extends StatefulWidget {
  MyHabits({Key key, this.userId, this.name}) : super(key: key);

  final String userId;
  final String name;

  @override
  _MyHabits createState() {
    return _MyHabits(userId: userId, name: name);
  }
}

class _MyHabits extends State<MyHabits> {
  _MyHabits({this.userId, this.name});

  final String userId;
  final String name;

  @override
  Widget build(BuildContext context) {
    print('myhabits: $userId $name');
    return MyScaffold(
      userId: userId,
      name: name,
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('welcome')
            .document('test_user')
            .collection('goals')
            .document('be cool')
            .collection('habits')
            // .where('outstanding', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          // print(Firestore.instance.collection('new_habit').snapshots());
          return _buildHabitList(context, snapshot.data.documents);
        },
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
      key: ValueKey(habitrecord.habit),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.purple),
        child: ListTile(
          title: Text(habitrecord.habit,
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
  final String habit;
  final bool outstanding;
  // final String frequency; // not using this currently
  final DocumentReference reference;

  HabitRecord.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['habit'] != null),
        assert(map['outstanding'] != null),
        // assert(map['frequency'] != null),
        habit = map['habit'],
        outstanding = map['outstanding'];
  // frequency = map['frequency'];

  HabitRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "HabitRecord<$habit$outstanding>";
}
