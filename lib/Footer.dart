import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Footer extends StatelessWidget {
  Footer({this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(userId)
            .collection('goals')
            .snapshots(),
        builder: (context, snapshot) {
          final int goalsCount = snapshot.data.documents.length;
          if (!snapshot.hasData) return new Text('loading...');
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Container(
                    color: Colors.green,
                    height: 20.0,
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
                  height: 50.0,
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
                            return Container(
                                height: 50.0,
                                width: 200.0,
                                margin: const EdgeInsets.only(bottom: 20.0),
                                child: ListTile(
                                  title: Text(goal['petName'],
                                      style: TextStyle(
                                          color: (goal['petHealth'] == 0)
                                              ? Colors.white
                                              : (goal['petHealth'] > 5)
                                                  ? Colors.pink
                                                  : Colors.pink[200],
                                          fontFamily: 'PressStart2P',
                                          fontSize: 16)),
                                  trailing:
                                      Image.asset('images/pixil-$petType.png'),
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
