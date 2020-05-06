import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:needy_new/GoalSetter.dart';
import 'package:needy_new/authentication.dart';
import 'package:needy_new/MyScaffold.dart';
import 'package:needy_new/MyHabits.dart';

class HomePage extends StatefulWidget {
  HomePage(
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
  _HomePageState createState() => new _HomePageState(
      userId: userId,
      name: name,
      logoutCallback: logoutCallback,
      auth: auth,
      logout: logout);
}

class _HomePageState extends State<HomePage> {
  _HomePageState(
      {Key key,
      this.auth,
      this.userId,
      this.logoutCallback,
      this.name,
      this.logout});

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String name;
  final bool logout;

  void logoutplease() {
    logoutCallback();
  }

  @override
  Widget build(BuildContext context) {
    getUsername(userId);
    print('welcome: $userId');
    updateToken();

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
                    .where('endDate', isGreaterThan: DateTime.now())
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Column(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: (name == null)
                            ? null
                            : Text(
                                'hi $name, welcome to Keeper!',
                                style: TextStyle(
                                  fontFamily: 'Pixelar',
                                  color: Colors.black,
                                  fontSize: 26,
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'hmmm it looks like you have no goals at the moment, would you like to set one up?',
                          style: TextStyle(
                            fontFamily: 'Pixelar',
                            color: Colors.black,
                            fontSize: 26,
                          ),
                        ),
                      ),
                      RaisedButton(
                        textColor: Colors.white,
                        color: Colors.pink,
                        child: Text(
                          'Create a new goal',
                          style: TextStyle(
                            fontFamily: 'PressStart2P',
                            color: Colors.yellow,
                          ),
                        ),
                        onPressed: () {
                          toGoalSetter(context);
                        },
                      )
                    ]);
                  } else {
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: (name == null)
                              ? null
                              : Text(
                                  'hi $name, welcome to Keeper!',
                                  style: TextStyle(
                                    fontFamily: 'Pixelar',
                                    color: Colors.black,
                                    fontSize: 26,
                                  ),
                                ),
                        ),
                        RaisedButton(
                          textColor: Colors.white,
                          color: Colors.pink,
                          child: Text(
                            'Create a new goal',
                            style: TextStyle(
                              fontFamily: 'PressStart2P',
                              color: Colors.yellow,
                            ),
                          ),
                          onPressed: () {
                            toGoalSetter(context);
                          },
                        ),
                        Text(
                          'Currently open goals:',
                          style: TextStyle(
                            fontFamily: 'Pixelar',
                            color: Colors.black,
                            fontSize: 26,
                          ),
                        ),
                        Expanded(
                            child: _buildGoalList(
                                context, snapshot.data.documents)),
                      ],
                    );
                  }
                }));
  }

  Future getUsername(userId) async {
    Firestore.instance.collection('users').document(userId).get().then((res) {
      name = (res['username']);
    });
  }

  Future toGoalSetter(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GoalSetter(userId: userId, name: name)));
  }

  updateToken() async {
    final dbRef = Firestore.instance;
    final token = await _firebaseMessaging.getToken();

    dbRef.collection('users').document(userId).updateData({
      'fcm': token,
    }).then((res) {
      print('fcm token updated');
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
    return Padding(
      key: ValueKey(goalRecord.petName),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.green[300]),
        child: ListTile(
            title: Text(
              goalRecord.goalName,
              style: TextStyle(
                fontFamily: 'Pixelar',
                fontSize: 26,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              goalRecord.petName,
              style: TextStyle(
                fontFamily: 'Pixelar',
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            trailing: (goalRecord.outstanding == true)
                ? Icon(
                    Icons.warning,
                    color: Colors.red,
                  )
                : SizedBox(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      MyHabits(userId: userId, name: name, goalName: goalName),
                ),
              );
            }),
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
