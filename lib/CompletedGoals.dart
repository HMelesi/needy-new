import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:needy_new/authentication.dart';
import 'package:needy_new/MyScaffold.dart';

class CompletedGoals extends StatefulWidget {
  CompletedGoals(
      {Key key,
      this.auth,
      this.userId,
      this.logoutCallback,
      this.name,
      this.logout})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final String name;
  final bool logout;

  @override
  State<StatefulWidget> createState() => new _CompletedGoalsState(
      userId: userId,
      name: name,
      logoutCallback: logoutCallback,
      auth: auth,
      logout: logout);
}

class _CompletedGoalsState extends State<CompletedGoals> {
  _CompletedGoalsState(
      {Key key,
      this.auth,
      this.userId,
      this.logoutCallback,
      this.name,
      this.logout});

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  String name;
  final bool logout;

  void logoutplease() {
    logoutCallback();
  }

  @override
  Widget build(BuildContext context) {
    getUsername(userId);
    print('welcome: $userId');
    // updateToken();

    return MyScaffold(
      auth: auth,
      logoutCallback: logoutCallback,
      name: name,
      userId: userId,
      body: (userId == null)
          ? Text('you idiot you have not passed the userid')
          : StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(userId)
                  .collection('goals')
                  .where('expired', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data.documents.length == 0) {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'There\'s nothing here! Try sticking with the goals you\'ve made.',
                          style: TextStyle(
                            fontFamily: 'Pixelar',
                            color: Colors.black,
                            fontSize: 26,
                          ),
                        ),
                      ),
                      Spacer(),
                      Image.asset('images/cobweb.png')
                    ],
                  );
                } else {
                  return Column(
                    children: <Widget>[
                      Text(
                        'Completed Goals:',
                        style: TextStyle(
                          fontFamily: 'Pixelar',
                          color: Colors.black,
                          fontSize: 26,
                        ),
                      ),
                      Expanded(
                          child:
                              _buildGoalList(context, snapshot.data.documents)),
                    ],
                  );
                }
              }),
    );
  }

  Future getUsername(userId) async {
    Firestore.instance.collection('users').document(userId).get().then((res) {
      name = (res['username']);
    });
  }

  Widget _buildGoalList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children:
          snapshot.map((data) => _buildGoalListItem(context, data)).toList(),
    );
  }

  Widget _buildGoalListItem(BuildContext context, DocumentSnapshot data) {
    final goalRecord = GoalRecord.fromSnapshot(data);
    final goalName = goalRecord.goalName;
    final petName = goalRecord.petName;
    final outstanding = goalRecord.outstanding;

    return Padding(
      key: ValueKey(goalRecord.petName),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.green[300]),
        child: ListTile(
          title: Text(
            goalName,
            style: TextStyle(
              fontFamily: 'Pixelar',
              fontSize: 26,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            petName,
            style: TextStyle(
              fontFamily: 'Pixelar',
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          trailing: (outstanding == true)
              ? Icon(
                  Icons.warning,
                  color: Colors.red,
                )
              : SizedBox(),
        ),
      ),
    );
  }
}

class GoalRecord {
  final Timestamp endDate;
  final String petName;
  final String goalName;
  final bool outstanding;
  final DocumentReference reference;

  GoalRecord.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['endDate'] != null),
        assert(map['petName'] != null),
        assert(map['goalName'] != null),
        assert(map['outstanding'] != null),
        endDate = map['endDate'],
        petName = map['petName'],
        goalName = map['goalName'],
        outstanding = map['outstanding'];

  GoalRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "goalRecord<$endDate$petName$goalName$outstanding>";
}
