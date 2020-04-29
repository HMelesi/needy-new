import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:needy_new/MyHabits.dart';
import 'package:needy_new/authentication.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple,
        body: Column(children: <Widget>[
          new StreamBuilder(
              stream: Firestore.instance
                  .collection('welcome')
                  .document('jamesinfo')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return new Text("Loading",
                      style: TextStyle(
                          fontFamily: 'PressStart2P', color: Colors.cyan));
                }
                var userDocument = snapshot.data;
                final name = userDocument["name"];
                final pet = userDocument["pet"];
                final goal = userDocument["goal"];
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: new Text(
                          'hi ${name}, it is time to get to work or ${pet} will die of starvation',
                          style: TextStyle(
                              fontFamily: 'PressStart2P', color: Colors.cyan)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: new Text('your current goal: ${goal}',
                          style: TextStyle(
                              fontFamily: 'PressStart2P',
                              color: Colors.yellow)),
                    ),
                  ],
                );
              }),
          MyHabits(testkey: 'working'),
        ]));
  }
}
