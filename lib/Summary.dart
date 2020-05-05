import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:needy_new/MyScaffold.dart';

class Summary extends StatefulWidget {
  Summary({Key key, this.userId, this.goalName});

  final String userId;
  final String goalName;

  @override
  _SummaryState createState() =>
      _SummaryState(userId: userId, goalName: goalName);
}

class _SummaryState extends State<Summary> {
  _SummaryState({this.userId, this.goalName});

  final String userId;
  final String goalName;

  final databaseReference = Firestore.instance;

  int incomplete;

  int complete;
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      userId: userId,
      body: Container(
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 500,
              child: SfCartesianChart(
                title: ChartTitle(text: 'Progress report'),
                primaryXAxis: CategoryAxis(title: AxisTitle(text: 'status')),
                primaryYAxis:
                    NumericAxis(title: AxisTitle(text: 'number of habits')),
                legend: Legend(
                  isVisible: true,
                ),
                series: <ChartSeries>[
                  ColumnSeries<HabitsData, String>(
                      name: 'goal name',
                      dataSource: getColumnData(),
                      xValueMapper: (HabitsData habits, _) => habits.x,
                      yValueMapper: (HabitsData habits, _) => habits.y)
                ],
              ),
            ),
            RaisedButton(
              child: Text('View Summary'),
              onPressed: () {
                getData();
              },
            ),
          ],
        )), //center
      ),
    );
  }

  getData() {
    var query = databaseReference
        .collection('users')
        .document(userId)
        .collection('goals')
        .document(goalName)
        .collection('habits');

    return query
        .where('outstanding', isEqualTo: true)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      incomplete = snapshot.documents.length;
      return incomplete;
      // snapshot.documents.forEach((f) => print('${f.data}, here')
      //     );
    }).then((incomplete) {
      return query
          .where('outstanding', isEqualTo: false)
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        complete = snapshot.documents.length;
        return [incomplete, complete];
      });
    }).then(([incomplete, complete]) {
      setState(() {
        complete = complete;
        incomplete = incomplete;
      });
    });
  }

  getColumnData() {
    print(incomplete);
    print(complete);
    List<HabitsData> columnData = <HabitsData>[
      HabitsData('incomplete', incomplete),
      HabitsData('complete', complete),
    ];
    return columnData;
  }
}

class HabitsData {
  String x;
  int y;

  HabitsData(this.x, this.y);
}
