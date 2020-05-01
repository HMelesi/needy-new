import 'package:needy_new/SignInSignUp.dart';
import 'package:needy_new/Welcome.dart';
import 'package:needy_new/authentication.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  RootPage({this.auth, this.userId, this.name, this.authstat});

  final BaseAuth auth;
  final String userId;
  final String name;
  final String authstat;

  @override
  State<StatefulWidget> createState() =>
      new _RootPageState(userId: userId, name: name, authstat: authstat);
}

class _RootPageState extends State<RootPage> {
  _RootPageState({this.userId, this.name, this.authstat});
  final String userId;
  final String name;
  final String authstat;

  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = '';
  String _name = "";
  final databaseReference = Firestore.instance;

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          if (userId != null) {
            print('homepage link');
            _name = name;
            _userId = userId;
          } else {
            _userId = user?.uid;
          }
        }
        if (authstat == 'logout') {
          print('logout link');
          authStatus = AuthStatus.NOT_LOGGED_IN;
        } else {
          authStatus = user?.uid == null
              ? AuthStatus.NOT_LOGGED_IN
              : AuthStatus.LOGGED_IN;
        }
      });
    });
  }

  void onNameChange(nom) {
    setState(() {
      if (name != null) {
        _name = name;
      } else {
        _name = nom;
      }
    });
  }

  void addNewUser(userid, nom) {
    databaseReference
        .collection('users')
        .document(userid)
        .setData({'username': nom}).then((res) {
      print('new user added to database');
    });
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
      _name = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return SignInSignUp(
          auth: widget.auth,
          loginCallback: loginCallback,
          onNameChange: onNameChange,
          addNewUser: addNewUser,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return HomePage(
              userId: _userId,
              auth: widget.auth,
              logoutCallback: logoutCallback,
              name: _name,
              logout: false);
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}
