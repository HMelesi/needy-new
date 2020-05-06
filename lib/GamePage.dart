import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:needy_new/MyScaffold.dart';

class GamePage extends StatefulWidget {
  GamePage(
      {this.userId, this.petName, this.goalName, this.petType, this.petHealth});

  final String userId;
  final String petName;
  final String goalName;
  final String petType;
  final int petHealth;

  @override
  _GamePage createState() {
    return _GamePage(
        userId: userId,
        petName: petName,
        goalName: goalName,
        petType: petType,
        petHealth: petHealth);
  }
}

class _GamePage extends State<GamePage> {
  _GamePage(
      {this.userId, this.petName, this.goalName, this.petType, this.petHealth});

  final String userId;
  final String petName;
  final String goalName;
  final String petType;
  int petHealth;

  @override
  Widget build(BuildContext context) {
    print('gamepage: $userId $goalName $petName');
    return MyScaffold(
      userId: userId,
      body: Text('gamepage'),
    );
  }
}
