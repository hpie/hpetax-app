import 'package:flutter/material.dart';

/*
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: FlatButton(
          child: new Text('Unregistered', style: new TextStyle(fontSize: 20.0, color: Colors.red)),
          onPressed: () {
            Navigator.pushNamed(context, '/unregistered');
          },
        ),
      ),
    );
  }
}
*/

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Stack(
              alignment: Alignment.center,
              children: <Widget>[
                new Container(
                  margin: new EdgeInsets.only(right: 225.0, bottom: 0.0),
                  height: 60.0,
                  width: 60.0,
                  decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(50.0),
                      color: Colors.orange
                  ),
                  child: new Icon(Icons.account_balance, color: Colors.white),
                ),
                new Container(
                  margin: new EdgeInsets.only(right: 75.0, top: 0.0),
                  height: 60.0,
                  width: 60.0,
                  decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(50.0),
                      color: Colors.blue
                  ),
                  child: new Icon(Icons.account_balance_wallet, color: Colors.white),
                ),
                new Container(
                  margin: new EdgeInsets.only(left: 225.0, top: 0.0),
                  height: 60.0,
                  width: 60.0,
                  decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(50.0),
                      color: Colors.redAccent
                  ),
                  child: new Icon(Icons.credit_card, color: Colors.white),
                ),
                new Container(
                  margin: new EdgeInsets.only(left: 75.0, bottom: 0.0),
                  height: 60.0,
                  width: 60.0,
                  decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(50.0),
                      color: Colors.green
                  ),
                  child: new Icon(Icons.supervised_user_circle, color: Colors.white),
                ),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text("Hp Tax", style: new TextStyle(fontSize: 30.0)),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FlatButton(
                        child: new Container(
                          alignment: Alignment.center,
                          height: 70.0,
                          decoration: new BoxDecoration( color: Colors.lightBlue, borderRadius: new BorderRadius.circular(10.0)),
                          child: new Text('Unregistered', style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/unregistered');
                        },
                      ),

                    ),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FlatButton(
                      child: new Container(
                        alignment: Alignment.center,
                        height: 70.0,
                        decoration: new BoxDecoration( color: Colors.lightBlue, borderRadius: new BorderRadius.circular(10.0)),
                        child: new Text('Unregistered2', style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/unregistered2');
                      },
                    ),

                  ),
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}

