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
  String total;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      userId: userId,
      body: Padding(
        padding: const EdgeInsets.only(left:10, top: 125, right: 10, bottom: 0),
        child: Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 420,
                child:  SfCircularChart(
                        annotations: <CircularChartAnnotation>[
                         CircularChartAnnotation(
                           child: Container(
                             child: PhysicalModel(
                              child: Container(),
                                shape: BoxShape.circle,
                                elevation: 10,
                                shadowColor: Colors.black,
                                color: const Color.fromRGBO(0, 230, 0, 1)))),
                                CircularChartAnnotation(
                                  child: Container(
                                  child: Text(total + '%\ncomplete',
                                 style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 0.5), fontSize: 25))))
                                   ],
                        series: <CircularSeries>[
                            DoughnutSeries<HabitsData, String>(
                                dataSource: getColumnData(),
                                pointColorMapper:(HabitsData data,  _) => data.color,
                                xValueMapper: (HabitsData data, _) => data.x,
                                yValueMapper: (HabitsData data, _) => data.y,
                                radius: '100%'
                            )
                        ]
                    ),
              ),
            ],
          ),
        ),
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
    }).then((incomplete) {
      return query
          .where('outstanding', isEqualTo: false)
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        complete = snapshot.documents.length;
        total = ((complete / (incomplete + complete)) * 100).toString(); 
        return [incomplete, complete, total];
      });
    }).then(([incomplete, complete, total]) {
      setState(() {
        complete = complete;
        incomplete = incomplete;
        total= total;
      });
    });
  }

  getColumnData() {
    List<HabitsData> columnData = <HabitsData>[
      HabitsData('complete', complete, Colors.blue),
      HabitsData('incomplete', incomplete, Colors.green[200]),
    ];
    return columnData;
  }
}

class HabitsData {
  String x;
  int y;
final Color color;
  HabitsData(this.x, this.y, this.color);
}
