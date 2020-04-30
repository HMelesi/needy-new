import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:needy_new/GoalSetter.dart';
// import 'package:needy_new/MyHabits.dart';
import 'package:needy_new/authentication.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback, this.name})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final String name;

  @override
  State<StatefulWidget> createState() => new _HomePageState(userId: userId);
}

class _HomePageState extends State<HomePage> {
  _HomePageState(
      {Key key, this.auth, this.userId, this.logoutCallback, this.name});

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  String name;

  @override
  Widget build(BuildContext context) {
    print(userId);
    return Column(
      children: <Widget>[
        (userId == null)
            ? Text('no userid')
            : new StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .document(userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return new Text("Loading");
                  }
                  var userDocument = snapshot.data;
                  name = userDocument["username"];
                  final goals = userDocument['goals'];
                  return Column(
                    children: <Widget>[
                      new Text('hi $name, welcome to the app!'),
                      (goals == null)
                          ? Column(
                              children: <Widget>[
                                Text(
                                    'hmmm it looks like you have no goals at the moment, would you like to set one up?'),
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
                          : Text('here are your goals'),
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
            widget.logoutCallback();
          },
        )
      ],
    );
  }

  Future toGoalSetter(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GoalSetter(userId: userId, name: name)));
  }
}
