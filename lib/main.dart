import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:hpetax/pages/challan.dart';
import 'package:hpetax/pages/dash.dart';
import 'package:hpetax/pages/invoice_recording.dart';
import 'package:hpetax/pages/landing.dart';
import 'package:hpetax/pages/login.dart';
import 'package:hpetax/pages/payment.dart';
import 'package:hpetax/pages/register.dart';
import 'package:hpetax/pages/test.dart';
import 'package:hpetax/pages/unregistered.dart';
import 'package:hpetax/pages/user_challan.dart';
import 'package:hpetax/util/device_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;


void main() {
  var frm_data = new DeviceData();
  globals.isLoggedIn = (frm_data.get_data()).toString();
  int _counter = 0;

  final flutterWebViewPlugin = FlutterWebviewPlugin();

  //Loading counter value on start
  _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    globals.username = prefs.getString('username');
    globals.usertype = prefs.getInt('usertype').toString();
  }

  _checkLogin();

  runApp(MaterialApp(
    title: 'HpTax',
    initialRoute: '/',
    routes: {
      '/': (context) => (globals.username == "" || globals.username == null) ? HomePage() : DashPage(),
      '/unregistered': (context) => UnregisteredPage(),
      '/dashboard': (context) => DashPage(),
      '/invoice_recording': (context) => InvoicePage(),
      '/user_challan': (context) => UserchallanPage(),
      '/test': (context) => TestPage(),
      '/login': (context) => LoginPage(),
      '/register': (context) => RegisterPage(),
      '/epayment': (context) => EpaymentPage(),
      '/payment': (context) => PaymentPage(),
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
      '/widget2': (_) {
        return WebviewScaffold(
          url: "https://hpie.in/hpetax/app-payment/5dea0e583c270",
          //url: "https://192.168.1.19/hpetax/app-payment/5de9e3958c7df",
          javascriptChannels: jsChannels,
          appBar: AppBar(
            title: const Text('Test payment'),
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

              ],
            ),
          ),
        );
      },
      '/widget3': (_) => new WebviewScaffold(
        url: "https://hpie.in/hpetax/app-payment/5de91036552ff",
        appBar: new AppBar(
          title: const Text('Widget webview'),
        ),
        withZoom: true,
        withLocalStorage: true,
        hidden: true,
        initialChild: Container(
          color: Colors.redAccent,
          child: const Center(
            child: Text('Waiting.....'),
          ),
        ),
      ),
    },
  ));
}



