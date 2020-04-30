import 'package:flutter/material.dart';
import 'package:needy_new/PropsTest.dart';
// import 'package:needy_new/MyHabits.dart';
// import 'package:needy_new/Welcome.dart';
// import 'package:needy_new/NewHabit.dart';
// import 'package:needy_new/authentication.dart';
// import 'package:needy_new/SignIn.dart';
// import 'package:needy_new/RootPage.dart';
import 'package:needy_new/RootPage.dart';
import 'package:needy_new/authentication.dart';


void main() {
  return runApp(MaterialApp(
    home: Scaffold(
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
      // body: NewHabit()
      body: RootPage(auth: Auth()),
    ),
    // body: NewHabit()
    // body: MyHabits(),
    // body: PropsTest(),
  )));
  ));
}
