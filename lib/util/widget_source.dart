import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'function_collection.dart';

TextStyle contentTxt = TextStyle(fontSize: 16.0);
TextStyle labelTxt = TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.grey);
TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

// Start listing widgets
Widget list_get_content(label, value, index) {
  return  Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
          const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
          child: Text(
            label,
            style: labelTxt,
            textAlign: TextAlign.start,
          ),
        ),
        Padding(
          padding:
          const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
          child: Text(
            value,
            style: contentTxt,
          ),
        )
      ]
  );
}

Widget list_get_location(label, value, index) {
  return  (value != "") ? Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
          const EdgeInsets.fromLTRB(4.0, 6.0, 12.0, 12.0),
          child: Text(
            label,
            style: labelTxt,
            textAlign: TextAlign.start,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: contentTxt,
          ),
        )
      ]
  ) : new SizedBox.shrink();
}

  //epayment form data submit button
  Widget list_submit_data(context, tax_queue) {
    return  new Row(
      children: <Widget>[
        Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.lightBlueAccent,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              if(tax_queue != null && tax_queue.length > 0) {
                Navigator.pushNamed(context, '/challan');
              } else {
                Toast.show("Please add items to queue", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
              }
            },
            child: Text("Submit",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
// End listing widgets

//form fields

Widget form_weight_field(weightCnt, commodityObj, _tax, totaltaxCnt) {
  return  Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      new Flexible(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: new TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: "Weight"
              ),
              keyboardType: TextInputType.number,
              controller: weightCnt,
              onChanged: (text) {
                print("Weight called : " + text);
                double single_price = commodityObj.tax_commodity_rate / commodityObj.tax_commodity_rate_unit;
                totaltaxCnt.text = (dp(double.parse(text) * single_price, 2 )).toString();
                _tax.weight = text;
              }
          ),
        ),
      ),
      new Align(
        alignment: Alignment.topLeft,
        child: Text(
          commodityObj.tax_commodity_unit_measure,
          style: TextStyle(
            // fontSize: 20,
            // fontWeight:FontWeight.bold
          ),
        ),
      )
    ],
  );
}

Widget form_distance_field(commodityObj, _tax, totaltaxCnt, distanceCnt, passengersCnt, distance) {
  return (distance == "1") ? new TextFormField(
      decoration: new InputDecoration(
        labelText: 'Distance (in Km) within HP',
      ),
      onChanged: (String text) {
        double single_price, calculated = 1;

        single_price = commodityObj.tax_commodity_rate / commodityObj.tax_commodity_rate_unit;

        calculated = calculated * single_price;

        if(text != "") {
          if (commodityObj.tax_commodity_isdistancedependent == "YES") {
            calculated = calculated * double.parse(text);
          }
        }

        if(passengersCnt.text != "") {
          if (commodityObj.tax_commodity_taxcalculation == "BY_COUNT") {
            calculated = calculated * double.parse(passengersCnt.text);
          }
        }

        totaltaxCnt.text = (dp(calculated, 2 )).toString();

        _tax.distance = text;
      },
      controller: distanceCnt
  ) : new SizedBox.shrink();
}

Widget form_passanger_field(commodityObj, _tax, totaltaxCnt, distanceCnt, passengersCnt, passengers) {
  return (passengers == "1") ? new TextFormField(
      decoration: new InputDecoration(
        labelText: 'No. of Passenger',
      ),
      onChanged: (String text) {
        double single_price,
            calculated = 1;

        single_price = commodityObj.tax_commodity_rate /
            commodityObj.tax_commodity_rate_unit;
        calculated = calculated * single_price;

        if(distanceCnt.text != "") {
          if (commodityObj.tax_commodity_isdistancedependent == "YES") {
            calculated = calculated * double.parse(distanceCnt.text);
          }
        }

        if(text != "") {
          if (commodityObj.tax_commodity_taxcalculation == "BY_COUNT") {
            calculated = calculated * double.parse(text);
          }
        }

        totaltaxCnt.text = (dp(calculated, 2 )).toString();

        _tax.quantity = text;
      },
      controller: passengersCnt
  ) : new SizedBox.shrink();
}

Widget form_vehicle_field(vehicleCnt, vehicleIsEnabled, _tax) {
  return TextFormField(
      decoration: new InputDecoration(
        labelText: 'Vehicle Number',
      ),
      enabled : vehicleIsEnabled,
      onChanged: (String val) {
        _tax.vehicle_number = val;
      },
      controller: vehicleCnt
  );
}

Widget form_total_field(totaltaxCnt, _tax) {
  return TextFormField(
      decoration: new InputDecoration(
        labelText: 'Total Tax (In Rs.)',
      ),
      enabled : false,
      onChanged: (String val) {
        _tax.total_tax = val;
      },
      controller: totaltaxCnt
  );
}

