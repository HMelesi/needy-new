import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:needy_new/GamePage.dart';

class Footer extends StatelessWidget {
  Footer({this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      body: (userId == null)
          ? Container(
              height: 70,
              width: 600,
              color: Colors.green,
              child: Row(
                children: <Widget>[
                  Image.asset('images/catgif.png'),
                  Text('loading...',
                      style: TextStyle(
                          color: Colors.yellow,
                          fontFamily: 'PressStart2P',
                          fontSize: 16)),
                ],
              ))
          : StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(userId)
                  .collection('goals')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return new Text('loading...');
                if (snapshot.hasData) {
                  final int goalsCount = snapshot.data.documents.length;
                  return Column(
                    children: <Widget>[
                      Container(
                          color: Colors.green,
                          height: 25.0,
                          width: 600.0,
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.arrow_left),
                              Text('play with your pets',
                                  style: TextStyle(
                                    fontFamily: 'Pixelar',
                                    fontSize: 24,
                                  )),
                              Icon(Icons.arrow_right),
                            ],
                          )),
                      Container(
                        color: Colors.green,
                        height: 45.0,
                        width: 600.0,
                        child: CustomScrollView(
                          // shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                if (index < goalsCount) {
                                  DocumentSnapshot goal =
                                      snapshot.data.documents[index];
                                  String petType = goal['petType'];
                                  String petName = goal['petName'];
                                  int petHealth = goal['petHealth'];
                                  String goalName = goal['goalName'];

                                  return Container(
                                      height: 50.0,
                                      width: 200.0,
                                      margin:
                                          const EdgeInsets.only(bottom: 20.0),
                                      child: FlatButton(
                                        child: Row(
                                          children: <Widget>[
                                            Text(petName,
                                                style: TextStyle(
                                                    color: (petHealth == 0)
                                                        ? Colors.white
                                                        : (petHealth > 5)
                                                            ? Colors.pink
                                                            : Colors.pink[200],
                                                    fontFamily: 'PressStart2P',
                                                    fontSize: 16)),
                                            Image.asset(
                                                'images/pixil-$petType.png'),
                                          ],
                                        ),
                                        onPressed: () {
                                          print('this is being tapped');
                                          (petHealth == 0)
                                              ? print(
                                                  'this pet is dead, you canot play with dead pets')
                                              : (petHealth > 5)
                                                  ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            GamePage(
                                                          userId: userId,
                                                          goalName: goalName,
                                                          petHealth: petHealth,
                                                          petType: petType,
                                                          petName: petName,
                                                        ),
                                                      ))
                                                  : print(
                                                      'this pet is not healthy enough to play right now');
                                        },
                                      ));
                                }
                                return null;
                              }),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Text('no pets to display');
                }
              },
            ),
    );
  }
}
