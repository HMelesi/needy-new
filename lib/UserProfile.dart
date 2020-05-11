import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:needy_new/MyScaffold.dart';
import 'package:needy_new/authentication.dart';

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

  @override
  Widget build(BuildContext context) {
    getUsername(userId);
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
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
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
                        child: Text(
                          'User since:',
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
                          'Total number of goals:',
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
                          'Goals completed:',
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
                    ],
                  ),
                );
              }),
    );
  }

  Future getUsername(userId) async {
    Firestore.instance.collection('users').document(userId).get().then((res) {
      name = (res['username']);
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
