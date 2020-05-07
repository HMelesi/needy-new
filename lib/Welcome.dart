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
                    .where('expired', isEqualTo: false)
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
    final outstanding = goalRecord.outstanding;
    final endDatePassed =
        goalRecord.endDate.toDate().difference(DateTime.now()).inSeconds < 0;

    return Padding(
      key: ValueKey(goalRecord.petName),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            color: (endDatePassed) ? Colors.green[900] : Colors.green[300]),
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
            trailing: (outstanding == true)
                ? Icon(
                    Icons.warning,
                    color: Colors.red,
                  )
                : (endDatePassed) ? Image.asset('images/trophy.png') : null,
            onTap: () {
              if (endDatePassed) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Stack(
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Positioned(
                              right: -40.0,
                              top: -40.0,
                              child: InkResponse(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: CircleAvatar(
                                  child: Icon(Icons.close),
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ),
                            Form(
                              key: Key('randomkey'),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        'Congratulations, you\'ve reached the end of this goal!'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        'Extend the goal if you want to carry on, or mark it complete.'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2001),
                                              lastDate: DateTime(2222),
                                            ).then((date) {
                                              extendGoal(goalName, date);
                                            });
                                          },
                                          child: Text('extend'),
                                        ),
                                        Spacer(),
                                        FlatButton(
                                          onPressed: () {
                                            completeGoal(goalName);
                                          },
                                          child: Text('complete'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => MyHabits(
                        userId: userId, name: name, goalName: goalName),
                  ),
                );
              }
            }),
      ),
    );
  }

  void completeGoal(goalName) async {
    final dbRef = Firestore.instance;
    await dbRef
        .collection('users')
        .document(userId)
        .collection('goals')
        .document(goalName)
        .updateData({
      'expired': true,
    }).then((res) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Goal completed!'),
        ),
      );
    }).catchError((err) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(err),
        ),
      );
    });
  }

  void extendGoal(goalName, updatedEndDate) async {
    final dbRef = Firestore.instance;
    await dbRef
        .collection('users')
        .document(userId)
        .collection('goals')
        .document(goalName)
        .updateData({
      'endDate': updatedEndDate,
    }).then((res) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Goal extended!'),
        ),
      );
    }).catchError((err) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(err),
        ),
      );
    });
  }
}

class GoalRecord {
  final Timestamp endDate;
  final String petName;
  final String goalName;
  final bool outstanding;
  final DocumentReference reference;
  final bool expired;

  GoalRecord.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['endDate'] != null),
        assert(map['petName'] != null),
        assert(map['goalName'] != null),
        assert(map['outstanding'] != null),
        assert(map['expired'] != null),
        endDate = map['endDate'],
        petName = map['petName'],
        goalName = map['goalName'],
        outstanding = map['outstanding'],
        expired = map['expired'];

  GoalRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "goalRecord<$endDate$petName$goalName$outstanding>";
}
