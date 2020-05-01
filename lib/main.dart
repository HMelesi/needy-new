import 'package:flutter/material.dart';
import 'package:needy_new/RootPage.dart';
import 'package:needy_new/authentication.dart';

void main() {
  return runApp(
    MaterialApp(
        initialRoute: '/',
        home: Scaffold(
          body: RootPage(auth: Auth()),
        )),
  );
}
