import 'package:flutter/material.dart';
import 'package:needy_new/Passing.dart';

class PropsTest extends StatefulWidget {
  @override
  _PropsTest createState() {
    return _PropsTest();
  }
}

class _PropsTest extends State<PropsTest> {
  final String testkey = 'chipie is cool';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple,
        body: Column(
          children: <Widget>[
            Text('this is the first page page, props: $testkey'),
            RaisedButton(
              textColor: Colors.white,
              color: Colors.pink,
              child: Text(
                'Go to second page',
                style: TextStyle(
                  fontFamily: 'PressStart2P',
                ),
              ),
              onPressed: () {
                navigateToSecondPage(context);
              },
            )
          ],
        ));
  }

  Future navigateToSecondPage(context) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Passing(testkey: testkey)));
  }
}
