import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:needy_new/GoalSetter.dart';
import 'package:needy_new/authentication.dart';
import 'package:needy_new/MyScaffold.dart';

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
  State<StatefulWidget> createState() => new _HomePageState(
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
  final String name;
  final bool logout;

  void logoutplease() {
    logoutCallback();
  }

  @override
  Widget build(BuildContext context) {
    print('welcome: $userId $name');
    return MyScaffold(
      auth: auth,
      logoutCallback: logoutCallback,
      name: name,
      userId: userId,
      body: logout
          ? Column(
              children: <Widget>[
                (userId == null)
                    ? Text('you idiot you have not passed the userid')
                    : Column(children: <Widget>[
                        new Text('hi $name, are you sure you want to logout?'),
                      ]),
                RaisedButton(
                  textColor: Colors.white,
                  color: Colors.pink,
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontFamily: 'PressStart2P',
                      color: Colors.yellow,
                    ),
                  ),
                  onPressed: () {
                    logoutplease();
                  },
                )
              ],
            )
          : Column(
              children: <Widget>[
                (userId == null)
                    ? Text('you idiot you have not passed the userid')
                    : new StreamBuilder(
                        stream: Firestore.instance
                            .collection('users')
                            .document(userId)
                            .collection('goals')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return LinearProgressIndicator();
                          }
                          var userDocument = snapshot.data;

                          final goals = userDocument['goals'];
                          final username = userDocument['username'];
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(

                                  'hi, welcome to the app!',

                                  style: TextStyle(
                                    fontFamily: 'PressStart2P',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              (goals == null)
                                  ? Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'hmmm it looks like you have no goals at the moment, would you like to set one up?',
                                            style: TextStyle(
                                              fontFamily: 'PressStart2P',
                                              color: Colors.white,
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
                                      ],
                                    )
                                  : Column(
                                      children: <Widget>[
                                        Text(
                                          'here are your goals',
                                          style: TextStyle(
                                            fontFamily: 'PressStart2P',
                                            color: Colors.white,
                                          ),
                                        ),
                                        _buildGoalList(context, goals),
                                      ],
                                    ),
                            ],
                          );
                        },
                      ),
                RaisedButton(
                  textColor: Colors.white,
                  color: Colors.pink,
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontFamily: 'PressStart2P',
                      color: Colors.yellow,
                    ),
                  ),
                  onPressed: () {
                    logoutplease();
                  },
                )
              ],
            ),
    );
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
      children:
          snapshot.map((data) => _buildGoalListItem(context, data)).toList(),
    );
  }

  Widget _buildGoalListItem(BuildContext context, DocumentSnapshot data) {
    final goalRecord = GoalRecord.fromSnapshot(data);

    return Padding(
      key: ValueKey(goalRecord.petName),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.purple),
        child: ListTile(
          title: Text(goalRecord.goalName),
        ),
      ),
    );
  }
}

class GoalRecord {
  final String endDate;
  final String petName;
  final String goalName;
  final DocumentReference reference;

  GoalRecord.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['endDate']),
        assert(map['petName']),
        assert(map['goalName']),
        endDate = map['endDate'],
        petName = map['petName'],
        goalName = map['goalName'];

  GoalRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "GoalRecord<$endDate$petName>";
}
