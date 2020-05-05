import 'package:flutter/material.dart';
import 'package:needy_new/Footer.dart';
import 'package:needy_new/GoalSetter.dart';
// import 'package:needy_new/MyHabits.dart';
// import 'package:needy_new/NewHabit.dart';
import 'package:needy_new/RootPage.dart';
import 'package:needy_new/authentication.dart';
// import 'package:needy_new/Welcome.dart';

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
      backgroundColor: Colors.purple,
      appBar: AppBar(
        title: Text(
          'KEEPER',
          style: TextStyle(
            fontFamily: 'PressStart2P',
            color: Colors.yellow,
          ),
        ),
        backgroundColor: Colors.purple,
      ),
      body: body,
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        ListTile(
          title: Text('homepage'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      RootPage(userId: userId, name: name, auth: Auth()),
                ));
          },
        ),
        ListTile(
            title: Text('create a new goal'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        GoalSetter(userId: userId, name: name),
                  ));
            }),
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
        )
      ])),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 70.0,
          child: Footer(userId: userId),
        ),
        color: Colors.cyan,
      ),
    );
  }
}
