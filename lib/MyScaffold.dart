import 'package:flutter/material.dart';
import 'package:needy_new/CompletedGoals.dart';
import 'package:needy_new/Footer.dart';
import 'package:needy_new/GoalSetter.dart';
// import 'package:needy_new/MyHabits.dart';
// import 'package:needy_new/NewHabit.dart';
import 'package:needy_new/RootPage.dart';
import 'package:needy_new/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:needy_new/Welcome.dart';
import 'package:needy_new/UserProfile.dart';

class MyScaffold extends StatelessWidget {
  MyScaffold(
      {this.body, this.userId, this.name, this.logoutCallback, this.auth});

  final BaseAuth auth;
  final Widget body;
  final String userId;
  final String name;

  final VoidCallback logoutCallback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[200],
        appBar: AppBar(
          title: Text(
            'KEEPER',
            style: TextStyle(
              fontFamily: 'PressStart2P',
              color: Colors.yellow,
            ),
          ),
          backgroundColor: Colors.green,
        ),
        body: body,
        drawer: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.green[400]),
          child: Drawer(
            child: SafeArea(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(
                        '$name',
                        style: TextStyle(
                          fontFamily: 'PressStart2P',
                          color: Colors.grey[700],
                          fontSize: 22,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  UserProfile(userId: userId, name: name),
                            ));
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'homepage',
                      style: TextStyle(
                        fontFamily: 'Pixelar',
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => RootPage(
                                userId: userId, name: name, auth: Auth()),
                          ));
                    },
                  ),
                  ListTile(
                      title: Text(
                        'create a new goal',
                        style: TextStyle(
                          fontFamily: 'Pixelar',
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  GoalSetter(userId: userId, name: name),
                            ));
                      }),
                  ListTile(
                    title: Text(
                      'Completed Goals',
                      style: TextStyle(
                        fontFamily: 'Pixelar',
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => CompletedGoals(
                                userId: userId, name: name, auth: Auth()),
                          ));
                    },
                  ),
                  // ListTile(
                  //     title: Text('create a new habit'),
                  //     onTap: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (BuildContext context) =>
                  //                 NewHabit(userId: userId, name: name),
                  //           ));
                  //     }),
                  // ListTile(
                  //     title: Text('my habits'),
                  //     onTap: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (BuildContext context) =>
                  //                 MyHabits(userId: userId, name: name),
                  //           ));
                  //     }),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => RootPage(
                                userId: userId,
                                name: name,
                                auth: Auth(),
                                authstat: 'logout'),
                          ));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.green,
          child: Container(
            height: 70.0,
            color: Colors.green,
            child: Footer(userId: userId, addBadges: addBadges),
          ),
        ));
  }

  void addBadges(number, goal) {
    Firestore.instance
        .collection('users')
        .document(userId)
        .updateData({'badges': FieldValue.increment(number)});

    // Firestore.instance
    //     .collection('users')
    //     .document(userId)
    //     .collection('goals')
    //     .document(goal)
    //     .updateData({'petHealth': 0});
  }
}
