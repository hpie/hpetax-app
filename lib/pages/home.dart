import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hpetax/globals.dart' as globals;
import 'package:hpetax/util/function_collection.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
          title: Text('Home'),
          automaticallyImplyLeading: false
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
                          height: 50.0,
                          width: 200.0,
                          decoration: new BoxDecoration( color: Colors.lightBlue, borderRadius: new BorderRadius.circular(10.0)),
                          child: new Text('Login', style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
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
                          height: 50.0,
                          width: 200.0,
                          decoration: new BoxDecoration( color: Colors.lightBlue, borderRadius: new BorderRadius.circular(10.0)),
                          child: new Text('Register', style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
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
                          height: 50.0,
                          width: 200.0,
                          decoration: new BoxDecoration( color: Colors.lightBlue, borderRadius: new BorderRadius.circular(10.0)),
                          child: new Text('Unregistered', style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/epayment_form');
                        },
                      ),

                    ),
                  ),
                ],
              ),
              new Center(
                child: new Text(globals.userSession),
              )
            ],
          )
      ),
    );
  }
}

