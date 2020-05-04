import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Footer extends StatelessWidget {
  Footer({this.userId});

  final String userId;

  // Stream<List<String>> loadData() async* {
  //   await Future.delayed(Duration(seconds: 3));
  //   yield List.generate(10, (index) => "Index $index");
  // }

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
          if (snapshot.hasData) {
            return CustomScrollView(
              // shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      while (index < goalsCount + 1) {
                        final DocumentSnapshot goal =
                            snapshot.data.documents[index];
                        return Container(
                          height: 30.0,
                          width: 200.0,
                          child: ListTile(
                            title: Text(goal['petName']),
                            trailing: Text(goal['petType']),
                          ),
                        );
                      }
                      return null;
                    },
                    childCount: 3,
                  ),
                )
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

// class Footer extends StatelessWidget {
//   Footer({this.userId});

//   final String userId;

//   @override
//   Widget build(BuildContext context) {
//     print('footer: $userId');
//     return CustomScrollView(
//       shrinkWrap: true,
//       scrollDirection: Axis.horizontal,
//       slivers: StreamBuilder<QuerySnapshot>(
//         stream: Firestore.instance.collection('users')
//             .document(userId)
//             .collection('goals')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return LinearProgressIndicator();
//           return _buildGoalList(context, snapshot.data.documents);
//         },
//       )
//     );
//   }
// }

// Widget _buildGoalList(
//       BuildContext context, List<DocumentSnapshot> snapshot) {
//     return SliverList(
//           delegate: SliverChildListDelegate(
//       // padding: const EdgeInsets.only(top: 20.0),
//       // children:
//           snapshot.map((data) => _buildGoalListItem(context, data)).toList(),
//     ));
// }

// Widget _buildGoalListItem(BuildContext context, DocumentSnapshot data) {
//     final goalrecord = GoalRecord.fromSnapshot(data);

//     return Padding(
//       key: ValueKey(goalrecord.pet),
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Container(
//         decoration: BoxDecoration(color: Colors.purple),
//         child: ListTile(
//           title: Text(goalrecord.pet,
//               style: TextStyle(
//                 fontFamily: 'PressStart2P',
//                 // color: (habitrecord.outstanding == true)
//                 //     ? Colors.red
//                 //     : Colors.grey,
//               )),
//           // onTap: () => habitrecord.reference
//           //     .updateData({'outstanding': !habitrecord.outstanding}),
//           // trailing: Icon(
//           //   (habitrecord.outstanding == true)
//           //       ? Icons.beach_access
//           //       : Icons.check,
//             // color: Colors.green,
//           ),
//         ),
//       );

//   }

// class GoalRecord {
//   // final String goal;
//   final String pet;
//   final String petname;

//   final DocumentReference reference;

//   GoalRecord.fromMap(Map<String, dynamic> map, {this.reference})
//       : assert(map['pet'] != null),
//         assert(map['petname'] != null),
//         pet = map['pet'],
//         petname = map['petname'];

//   GoalRecord.fromSnapshot(DocumentSnapshot snapshot)
//       : this.fromMap(snapshot.data, reference: snapshot.reference);

//   @override
//   String toString() => "GoalRecord<$pet$petname>";
// }

//       // <Widget>[
//       //   SliverList(
//       //     delegate: SliverChildListDelegate(
//       //       [
//       //         Text("Header 1"),
//       //         Text("Header 2"),
//       //         Text("Header 3"),
//       //         Text("Header 4"),
//       //         Text("Header 5"),
//       //         Text("Header 6"),
//       //         Text("Header 7"),
//       //         Text("Header 8"),
//       //       ],
//       //     ),
//       //   ),
//       // ],
