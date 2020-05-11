import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:needy_new/MyScaffold.dart';
import 'package:needy_new/authentication.dart';
import 'package:intl/intl.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key key, this.auth, this.userId, this.name}) : super(key: key);

  final BaseAuth auth;
  final String userId;
  final String name;

  @override
  _UserProfileState createState() =>
      new _UserProfileState(userId: userId, name: name, auth: auth);
}

class _UserProfileState extends State<UserProfile> {
  _UserProfileState({Key key, this.auth, this.userId, this.name});

  final BaseAuth auth;
  final String userId;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String name;
  Timestamp userSince;
  int goalCount = 0;
  int completedGoals = 0;
  int badgeCount = 0;

  @override
  Widget build(BuildContext context) {
    getUserInfo(userId);
    getGoalCount(userId);
    getCompletedGoals(userId);
    print('user profile for $userId');
    updateToken();

    return MyScaffold(
      // auth: auth,
      name: name,
      userId: userId,
      body: (userId == null)
          ? Text('userid not passed')
          : StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(userId)
                  .collection('goals')
                  .where('expired', isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 48.0,
                            child: Image.asset('images/catgif.gif'),
                          ),
                        ),
                        Text(
                          'Loading profile...',
                          style: TextStyle(
                            fontFamily: 'PressStart2P',
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 48.0,
                              child: Image.asset('images/catgif.gif'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              '$name',
                              style: TextStyle(
                                fontFamily: 'PressStart2P',
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: (userSince == null)
                                ? Text(
                                    'User since: Loading...',
                                    style: TextStyle(
                                      fontFamily: 'Pixelar',
                                      fontSize: 26,
                                      color: Colors.grey[800],
                                    ),
                                  )
                                : Text(
                                    'User since: ${DateFormat.yMMMMEEEEd().format(userSince.toDate())}',
                                    style: TextStyle(
                                      fontFamily: 'Pixelar',
                                      fontSize: 26,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Total number of goals: $goalCount',
                              style: TextStyle(
                                fontFamily: 'Pixelar',
                                fontSize: 26,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Goals completed: $completedGoals',
                              style: TextStyle(
                                fontFamily: 'Pixelar',
                                fontSize: 26,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'Badges',
                              style: TextStyle(
                                fontFamily: 'PressStart2P',
                                fontSize: 22,
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: SizedBox(
                                  height: 200.0,
                                  child: GridView.count(
                                    crossAxisCount: 3,
                                    children:
                                        List.generate(badgeCount, (index) {
                                      return Center(
                                        child: Image.asset(
                                          'images/pixil-badge.png',
                                          width: 70,
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }),
    );
  }

  Future getUserInfo(userId) async {
    Firestore.instance.collection('users').document(userId).get().then((res) {
      name = (res['username']);
      userSince = (res['userSince']);
      badgeCount = (res['badges']);
    });
  }

  Future getGoalCount(userId) async {
    Firestore.instance
        .collection('users')
        .document(userId)
        .collection('goals')
        .getDocuments()
        .then((res) {
      goalCount = res.documents.length;
    });
  }

  Future getCompletedGoals(userId) async {
    Firestore.instance
        .collection('users')
        .document(userId)
        .collection('goals')
        .where('expired', isEqualTo: true)
        .getDocuments()
        .then((res) {
      completedGoals = res.documents.length;
    });
  }

  updateToken() async {
    final dbRef = Firestore.instance;
    final token = await _firebaseMessaging.getToken();

    dbRef.collection('users').document(userId).updateData({
      'fcm': token,
    }).then((res) {
      print('fcm token update');
    });
  }
}
