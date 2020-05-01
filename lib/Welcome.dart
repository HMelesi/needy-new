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
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return new Text("Loading");
                          }
                          var userDocument = snapshot.data;
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
}
