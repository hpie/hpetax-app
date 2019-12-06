import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:hpetax/networklayer/challan.dart';
import 'package:hpetax/networklayer/epayment.dart';
import 'package:hpetax/networklayer/epayment_api.dart';
import 'package:hpetax/util/device_data.dart';
import 'package:hpetax/util/validations.dart';
import 'package:hpetax/globals.dart' as globals;

/* ============== Start webview declarations ==================== */
const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

//String selectedUrl = 'https://hpie.in/hpetax/payment.php?id=' + globals.challanId;

String selectedUrl = globals.paymentUrl + globals.challanId;

// ignore: prefer_collection_literals
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
        //flutterWebviewPlugin.close();
      }),
].toSet();
/* ============== End webview declarations ==================== */

class PaymentPage extends StatefulWidget {
  @override
  _Payment createState() {
    var frm_data = new DeviceData();
    frm_data.get_data();
    return _Payment();
  }
}

class _Payment extends State<PaymentPage> {

  final _formKey = GlobalKey<FormState>();

  EpaymentApi _epaymentApi = new EpaymentApi();
  Epayment _epayment = new Epayment();
  CustomValidations _customValidations = new CustomValidations();

  final customLoaderField =  CircularProgressIndicator();

  List<Challan> challan_queue;
  bool is_loading = false;
  bool payment_called = true;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  List<String> data_items = [];
  TextEditingController challanIdCnt = TextEditingController();
  final TextEditingController referenceCtrl = new TextEditingController();
  final TextEditingController amountCtrl = new TextEditingController();
  final TextEditingController tenderByCtrl = new TextEditingController();
  final TextEditingController fromCtrl = new TextEditingController();
  final TextEditingController toCtrl = new TextEditingController();
  final TextEditingController statusCtrl = new TextEditingController();
  final TextEditingController transactionStatusCtrl = new TextEditingController();

  /* ============== Start webview declarations ==================== */
  // Instance of WebView plugin
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  // On destroy stream
  StreamSubscription _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  StreamSubscription<WebViewHttpError> _onHttpError;

  StreamSubscription<double> _onProgressChanged;

  StreamSubscription<double> _onScrollYChanged;

  StreamSubscription<double> _onScrollXChanged;

  final _urlCtrl = TextEditingController(text: selectedUrl);

  final _codeCtrl = TextEditingController(text: 'window.navigator.userAgent');

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _history = [];
  /* ============== End webview declarations ====================== */

  @override
  void initState() {
    super.initState();
    print("payment init called");
    listTaxItemQueue(globals.challanId, true);



    /* ============== Start webview Methods ==================== */
    flutterWebViewPlugin.close();

    _urlCtrl.addListener(() {
      selectedUrl = _urlCtrl.text;
    });

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      print("before mounted check destroyed");
      if (mounted) {
        print("destroyed");
        // Actions like show a info toast.
        _scaffoldKey.currentState.showSnackBar(
            const SnackBar(content: const Text('Webview Destroyed')));
      }
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {

      if (mounted) {
        setState(() {
          _history.add('onUrlChanged: $url');
          print("Url changed : " + url);
          //print("return url : " + globals.updatepaymentUrl + globals.challanId);
          /*
          if(globals.updatepaymentUrl + globals.challanId == url) {
            flutterWebViewPlugin.close();
            print("close called");
          }
          */
        });
      }
    });

    _onProgressChanged =
        flutterWebViewPlugin.onProgressChanged.listen((double progress) {
          if (mounted) {
            setState(() {
              _history.add('onProgressChanged: $progress');
            });
          }
        });

    _onScrollYChanged =
        flutterWebViewPlugin.onScrollYChanged.listen((double y) {
          if (mounted) {
            setState(() {
              _history.add('Scroll in Y Direction: $y');
            });
          }
        });

    _onScrollXChanged =
        flutterWebViewPlugin.onScrollXChanged.listen((double x) {
          if (mounted) {
            setState(() {
              _history.add('Scroll in X Direction: $x');
            });
          }
        });

    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {

          print('onStateChanged: ${state.type} ${state.url}');
          if (mounted) {
            setState(() {
              _history.add('onStateChanged: ${state.type} ${state.url}');
            });
          }
        });

    _onHttpError =
        flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
          if (mounted) {
            setState(() {
              _history.add('onHttpError: ${error.code} ${error.url}');
            });
          }
        });

    WidgetsBinding.instance
        .addPostFrameCallback((_) => load_webview(context));
    /* ============== End webview Methods ====================== */
  }

  /* ============== Start webview Methods ==================== */
  void load_webview(context) {
    Navigator.of(context).pushNamed('/widget');
  }

  @override
  void dispose() {
    print("dispose called");
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onProgressChanged.cancel();
    _onScrollXChanged.cancel();
    _onScrollYChanged.cancel();

    flutterWebViewPlugin.dispose();

    super.dispose();
  }
/* ============== End webview Methods ====================== */

  Future listTaxItemQueue(String newQuery, bool is_insert) async {
    is_loading = true;
    print("chalan parameter : " + newQuery);
    var search = await _epaymentApi.challan_list_for_payment(newQuery, is_insert);
    print(search.list[0].tax_challan_id);
    setState(() {
      is_loading = false;
      challan_queue = search.list;

      referenceCtrl.text = search.list[0].queue_session;
      amountCtrl.text = search.list[0].tax_challan_amount;
      tenderByCtrl.text = search.list[0].tax_depositors_name;
      fromCtrl.text = search.list[0].tax_challan_from_dt;
      toCtrl.text = search.list[0].tax_challan_to_dt;
      statusCtrl.text = search.list[0].tax_challan_status;
      transactionStatusCtrl.text = search.list[0].tax_transaction_status;

      if(search.list[0].tax_transaction_status == "PENDING" && !is_insert) {
        payment_called = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Payment"),
          automaticallyImplyLeading:false,
        ),
        body:  new SingleChildScrollView(

          child: new Container(
            alignment: Alignment.topLeft,
            child: new Form(key: _formKey,child: formUI()),
            //child: new Form(key: _formKey,child: Text("Hello")),
          ),
        )
    );
  }

  Widget formUI() {

    challanIdCnt.text = globals.challanId;

    return new Column(
      children: <Widget>[
        TextFormField(
          //initialValue: 'Pune',
            decoration: new InputDecoration(
              labelText: 'Tax Challan ID',
            ),
            enabled : false,
            onSaved: (String val) {
              //_invoice.ship_to = val;
            },
            controller: challanIdCnt
        ),
        TextFormField(
            //initialValue: 'Pune',
            decoration: new InputDecoration(
            labelText: 'Reference Number',
        ),
            enabled : false,
        onSaved: (String val) {
        //_invoice.ship_to = val;
        },
        controller: referenceCtrl
        ),
        TextFormField(
          //initialValue: 'Pune',
            decoration: new InputDecoration(
              labelText: 'Amount',
            ),
            enabled : false,
            onSaved: (String val) {
              //_invoice.ship_to = val;
            },
            controller: amountCtrl
        ),
        TextFormField(
          //initialValue: 'Pune',
            decoration: new InputDecoration(
              labelText: 'Tender By',
            ),
            enabled : false,
            onSaved: (String val) {
              //_invoice.ship_to = val;
            },
            controller: tenderByCtrl
        ),
        TextFormField(
          //initialValue: 'Pune',
            decoration: new InputDecoration(
              labelText: 'Period From',
            ),
            enabled : false,
            onSaved: (String val) {
              //_invoice.ship_to = val;
            },
            controller: fromCtrl
        ),
        TextFormField(
          //initialValue: 'Pune',
            decoration: new InputDecoration(
              labelText: 'Period To',
            ),
            enabled : false,
            onSaved: (String val) {
              //_invoice.ship_to = val;
            },
            controller: toCtrl
        ),
        /*
        TextFormField(
          //initialValue: 'Pune',
            decoration: new InputDecoration(
              labelText: 'Challan Status',
            ),
            enabled : false,
            onSaved: (String val) {
              //_invoice.ship_to = val;
            },
            controller: statusCtrl
        ),
        */
        TextFormField(
          //initialValue: 'Pune',
            decoration: new InputDecoration(
              labelText: 'Challan Transaction Status',
            ),
            enabled : false,
            onSaved: (String val) {
              //_invoice.ship_to = val;
            },
            controller: transactionStatusCtrl
        ),
        SizedBox(
          height: 20.0,
        ),
        (!payment_called) ? Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.greenAccent,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              setState(() {
                //isLoading = true;
                payment_called = true;
                //_launchURL();
                Navigator.of(context).pushNamed('/widget');
              });
              //_validateInputs(context);
              //register_user(context);
            },
            child: Text("Make Payment",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ) : Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.greenAccent,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              listTaxItemQueue(challanIdCnt.text, false);
            },
            child: Text("Refresh",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xff01A0C7),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              Navigator.pushNamed(context, '/test');
            },
            child: Text("Back",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),


        /*
        const SizedBox(height: 30),

        new Row(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                _launchURL();
              },
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 20)
                ),
              ),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/test');
              },
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: const Text(
                    'Back',
                    style: TextStyle(fontSize: 20)
                ),
              ),
            ),
            RaisedButton(
              onPressed: () {
                listTaxItemQueue(challanIdCnt.text);
              },
              child: Text('get datar'),
            )

            /*
            RaisedButton(
              onPressed: _launchURL,
              child: Text('Make Payment'),
            ),
            */
          ],
        ),
        */
      ],
    );
  }










}

