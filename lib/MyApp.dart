import 'dart:async';
import 'package:flutter/material.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:needy_new/Welcome.dart';
import 'package:needy_new/authentication.dart';

class MyApp extends StatefulWidget {
  MyApp(
      {this.auth,
      this.userId,
      this.name,
      this.authstat,
      this.logoutCallback,
      this.logout});

  final BaseAuth auth;
  final String userId;
  final String name;
  final String authstat;
  final VoidCallback logoutCallback;
  final bool logout;

  @override
  _MyAppState createState() => new _MyAppState(
      userId: userId,
      name: name,
      logoutCallback: logoutCallback,
      auth: auth,
      logout: logout);
}

class _MyAppState extends State<MyApp> {
  _MyAppState(
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

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            startOnBoot: true,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.NONE), (String taskId) async {
      // This is the fetch-event callback.

      final dbRef = Firestore.instance;
      var goals = await dbRef
          .collection('users')
          .document(userId)
          .collection('goals')
          .getDocuments();
      var goalsList = goals.documents
          .map((doc) => doc.data)
          .toList()
          .map((info) => info['goalName'].toString())
          .toList();
      if (goalsList.length > 0) {
        goalsList.forEach((goal) async {
          var habits = await dbRef
              .collection('users')
              .document(userId)
              .collection('goals')
              .document(goal)
              .collection('habits')
              .getDocuments();
          var habitList = habits.documents
              .map((doc) => doc.data)
              .toList()
              .map((info) => {
                    'name': info['habitName'],
                    'freq': info['frequency'],
                    'time': info['time'],
                    'goal': goal,
                  })
              .toList();

          habitList.forEach((habit) {
            var timeDiff = DateTime.now().difference(habit['time'].toDate());
            if (timeDiff.inSeconds > 86400 * habit['freq']) {
              dbRef
                  .collection('users')
                  .document(userId)
                  .collection('goals')
                  .document(goal)
                  .collection('habits')
                  .document(habit['name'])
                  .updateData({'outstanding': true});
            }
          });
        });
      }

      BackgroundFetch.finish(taskId);
    }).then((int status) {
      print('[BackgroundFetch] configure success: $status');
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return HomePage(
        userId: userId,
        auth: widget.auth,
        logoutCallback: logoutCallback,
        logout: false);
  }
}
