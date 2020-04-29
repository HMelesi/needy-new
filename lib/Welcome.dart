import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    return Column(children: <Widget>[
      new StreamBuilder(
          stream: Firestore.instance
              .collection('welcome')
              .document('jamesinfo')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return new Text("Loading");
            }
            var userDocument = snapshot.data;
            final name = userDocument["name"];
            final pet = userDocument["pet"];
            final goal = userDocument["goal"];
            return new Text(
                'hi ${name}, it is time to get to work now on your goal of "${goal}" or ${pet} will die of starvation');
          }),
    ]);
  }
}
