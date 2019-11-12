import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:hp_one/globals.dart' as globals;

class DashboardPage extends StatelessWidget {





  @override
  Widget build(BuildContext context) {
    //Loading counter value on start
    _logOut() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', "");
      prefs.setInt('usertype', null);

      globals.username = "";
      globals.usertype = null;

      print("logged out");
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashbaord'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.power_settings_new),
            onPressed: () {
              _logOut();
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text("Welcome", style: new TextStyle(fontSize: 30.0)),
                ),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(globals.username, style: new TextStyle(fontSize: 20.0)),
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
                        child: new Text('Profile', style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/profile');
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
                        child: new Text('Challan', style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/user_challan');
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
                        child: new Text('LogOut', style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/logout');
                      },
                    ),

                  ),
                ),
              ],
            ),

          ],
        )
      ),
    );
  }
}

