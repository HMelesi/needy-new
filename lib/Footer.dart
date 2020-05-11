import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:needy_new/game/lib/GameMain.dart';

class Footer extends StatelessWidget {
  Footer({this.userId, this.addBadges});

  final String userId;

  final Function(int, String) addBadges;

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
                      // Container(
                      //     color: Colors.green,
                      //     height: 25.0,
                      //     width: 600.0,
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: <Widget>[
                      //         // Icon(Icons.arrow_left),
                      //         Text('<   play with your pets   >',
                      //             style: TextStyle(
                      //               fontFamily: 'Pixelar',
                      //               fontSize: 24,
                      //             )),
                      //         // Icon(Icons.arrow_right),
                      //       ],
                      //     )),
                      Container(
                        color: Colors.green,
                        height: 60.0,
                        width: 600.0,
                        child: CustomScrollView(
                          // shrinkWrap: true,
                          scrollDirection: Axis.horizontal,

                          slivers: [
                            const SliverAppBar(
                              automaticallyImplyLeading: false,
                              pinned: true,
                              title: Text('PLAY >',
                                  style: TextStyle(
                                      color: Colors.yellow,
                                      fontFamily: 'Pixelar',
                                      fontSize: 20)),
                              expandedHeight: 90.0,
                              backgroundColor: Colors.green,
                            ),
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
                                      width: 220,
                                      child: FlatButton(
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.asset(
                                                  'images/pixil-$petType.png'),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(petName,
                                                    style: TextStyle(
                                                        color: (petHealth == 0)
                                                            ? Colors.white
                                                            : (petHealth > 5)
                                                                ? Colors.pink
                                                                : Colors
                                                                    .pink[200],
                                                        fontFamily:
                                                            'PressStart2P',
                                                        fontSize: 15)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onPressed: () {
                                          (petHealth == 0)
                                              ? showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                        backgroundColor:
                                                            Colors.yellow,
                                                        content: Stack(
                                                            overflow: Overflow
                                                                .visible,
                                                            children: <Widget>[
                                                              Positioned(
                                                                right: -40.0,
                                                                top: -40.0,
                                                                child:
                                                                    InkResponse(
                                                                  onTap: () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      CircleAvatar(
                                                                    child: Icon(
                                                                        Icons
                                                                            .close),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .pink,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                height: 180.0,
                                                                child: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Image.asset(
                                                                        'images/pixil-$petType.png'),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          20.0),
                                                                      child: Text(
                                                                          '$petName is dead. You cannot play with dead pets.',
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Pixelar',
                                                                            fontSize:
                                                                                26,
                                                                            color:
                                                                                Colors.black,
                                                                          )),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ]));
                                                  })
                                              : (petHealth > 5)
                                                  ? showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                            backgroundColor:
                                                                Colors.yellow,
                                                            content: Stack(
                                                                overflow:
                                                                    Overflow
                                                                        .visible,
                                                                children: <
                                                                    Widget>[
                                                                  Positioned(
                                                                    right:
                                                                        -40.0,
                                                                    top: -40.0,
                                                                    child:
                                                                        InkResponse(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          CircleAvatar(
                                                                        child: Icon(
                                                                            Icons.close),
                                                                        backgroundColor:
                                                                            Colors.pink,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height:
                                                                        250.0,
                                                                    child:
                                                                        Column(
                                                                      children: <
                                                                          Widget>[
                                                                        Image.asset(
                                                                            'images/pixil-$petType.png'),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(20.0),
                                                                          child: Text(
                                                                              'Well done! $petName is healthy enough to play!',
                                                                              style: TextStyle(
                                                                                fontFamily: 'Pixelar',
                                                                                fontSize: 26,
                                                                                color: Colors.black,
                                                                              )),
                                                                        ),
                                                                        RaisedButton(
                                                                          color:
                                                                              Colors.pink,
                                                                          child:
                                                                              Text(
                                                                            'START GAME',
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'PressStart2P',
                                                                              color: Colors.yellow,
                                                                            ),
                                                                          ),
                                                                          onPressed: () => gamestart(
                                                                              userId,
                                                                              goalName,
                                                                              petHealth,
                                                                              petType,
                                                                              petName,
                                                                              addBadges),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ]));
                                                      })
                                                  : showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                            backgroundColor:
                                                                Colors.yellow,
                                                            content: Stack(
                                                                overflow:
                                                                    Overflow
                                                                        .visible,
                                                                children: <
                                                                    Widget>[
                                                                  Positioned(
                                                                    right:
                                                                        -40.0,
                                                                    top: -40.0,
                                                                    child:
                                                                        InkResponse(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          CircleAvatar(
                                                                        child: Icon(
                                                                            Icons.close),
                                                                        backgroundColor:
                                                                            Colors.pink,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height:
                                                                        230.0,
                                                                    child:
                                                                        Column(
                                                                      children: <
                                                                          Widget>[
                                                                        Image.asset(
                                                                            'images/pixil-$petType.png'),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(20.0),
                                                                          child: Text(
                                                                              '$petName is not healthy enough to play a game right now, stick to your habits to improve $petName\'s health.',
                                                                              style: TextStyle(
                                                                                fontFamily: 'Pixelar',
                                                                                fontSize: 26,
                                                                                color: Colors.black,
                                                                              )),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ]));
                                                      });
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
