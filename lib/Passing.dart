import 'package:flutter/material.dart';

class Passing extends StatefulWidget {
  Passing({Key key, this.testkey});

  final String testkey;

  @override
  _Passing createState() {
    return _Passing(testkey: testkey);
  }
}

class _Passing extends State<Passing> {
  _Passing({Key key, this.testkey});

  final String testkey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: Column(
          children: <Widget>[
            SizedBox(
              width: 500.0,
              height: 300.0,
              child:
                  Text('and on the second page, here are the props: $testkey'),
            ),
            RaisedButton(
              textColor: Colors.white,
              color: Colors.pink,
              child: Text(
                'Back to first page',
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                  color: Colors.yellow,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ));
  }
}
