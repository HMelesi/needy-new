import 'package:flutter/material.dart';
// import 'package:needy_pet/authentication.dart';
// import 'package:needy_pet/Welcome.dart';
// import 'package:needy_pet/SignIn.dart';
// import 'package:needy_new/RootPage.dart';

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
        body: Text('WE WILL NOT BE BEATEN BY FLUTTER')
        // body: new RootPage(auth: new Auth()),
        ),
  ));
}
