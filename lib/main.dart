import 'dart:async';
import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'pages/invoice_recording.dart';
import 'pages/record_invoice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/challan.dart';
import 'pages/dash.dart';
import 'pages/epaymentform.dart';
import 'pages/home.dart';
import 'globals.dart' as globals;
import 'pages/login.dart';
import 'pages/payment.dart';
import 'pages/register.dart';
import 'util/function_collection.dart';


void main() {
  runApp(new MaterialApp(
    home: new SplashScreen(),
    routes: <String, WidgetBuilder>{
      '/landing': (context) => HomePage(),
      '/login': (context) => LoginPage(),
      '/register': (context) => RegisterPage(),
      '/dashboard': (context) => DashPage(),
      '/epayment_form': (context) => EpaymentformPage(),
      '/challan': (context) => ChallanPage(),
      '/payment': (context) => PaymentPage(),
      '/record_invoice': (context) => RecordinvoicePage(),
      '/invoice_recording': (context) => InvoicePage(),
      '/widget': (_) {
        return WebviewScaffold(
          url: selectedUrl,
          javascriptChannels: jsChannels,
          appBar: AppBar(
            title: const Text('Payment'),
          ),
          withZoom: true,
          withLocalStorage: true,
          hidden: true,
          initialChild: Container(
            color: Colors.grey,
            child: const Center(
              child: Text('Waiting.....'),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              children: <Widget>[
                /*
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    flutterWebViewPlugin.goBack();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    flutterWebViewPlugin.goForward();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.autorenew),
                  onPressed: () {
                    flutterWebViewPlugin.reload();
                  },
                ),
                */
              ],
            ),
          ),
        );
      },
    },
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _deviceid = 'Unknown';
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    final prefs = await SharedPreferences.getInstance();

    print("===== : " + prefs.getInt('isLoggedIn').toString());
    if(prefs.getInt('isLoggedIn') != null) {

      globals.username    = prefs.getString('username');
      globals.usertype    = prefs.getInt('usertype').toString();
      globals.userid      = prefs.getInt('userid').toString();
      globals.isLoggedIn  = prefs.getInt('isLoggedIn').toString();

      Navigator.of(context).pushReplacementNamed('/dashboard');
    } else {
      Navigator.of(context).pushReplacementNamed('/landing');
    }
  }

  @override
  void initState() {
    super.initState();
    initDeviceId();
    startTime();
  }

  Future<void> initDeviceId() async {
    String deviceid;
    String imei;
    String meid;

    deviceid = await DeviceId.getID;
    try {
      imei = await DeviceId.getIMEI;
      meid = await DeviceId.getMEID;
    } on PlatformException catch (e) {
      print(e.message);
    }

    if (!mounted) return;

    setState(() {
      _deviceid = 'Your deviceid: $deviceid\nYour IMEI: $imei\nYour MEID: $meid';
      globals.device_id = deviceid;
      set_session();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Image.asset('images/flutter_icon.png'),
      ),
    );
  }
}