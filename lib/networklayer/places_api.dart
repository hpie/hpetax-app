import 'dart:async';
import 'dart:convert';

import 'package:hpetax/networklayer/searchplacesmodel.dart';

import 'challanitemmodel.dart';

import 'package:hpetax/globals.dart' as globals;

import 'network_util.dart';

class PlacesApi {

  NetworkUtil _netUtil = new NetworkUtil();

  //Future<TaxitemModel> search(String query) {
  Future<dynamic> get_places(String query) {
   // print("=======called challan initial data=======" + query);
    String placesApiKey = globals.googlePlacesApiKey;
    //String BASE_TOKEN_URL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input="+query+"&key=AIzaSyBIP2JwuoMf2B52uoQ6Cu88PrkWq8oId-Y";
    //String BASE_TOKEN_URL = "http://hpie.in/hpetax/places.json";
    String BASE_TOKEN_URL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input="+query+"&key="+placesApiKey;

   // print("=======places url =======" + BASE_TOKEN_URL);
    var match = {
      "queue_session": globals.userSession,
      "token": "123",
      "device": "android",
    };

    return _netUtil.get(BASE_TOKEN_URL,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        encoding: Encoding.getByName("utf-8")).then((dynamic res) {
      /*
      print("=======places data=======");
      print(res["predictions"]);
      print("=======places data=======");
      */
      //var results = Epayment.fromJson(res["Result"]);

      var results = new SearchplacesModel.searchResult(res["predictions"]);
      /*
      print("=======places data=======");
      print("Description at 0" + results.list[0].description);
      print("=======places data=======");
      */
      //results.status = 200;
      return results.list;
    });
  }

  Future<dynamic> get_distance(String source, String destination) {
    print("=======get_distance source =======" + source);
    print("=======get_distance destination=======" + destination);
    String placesApiKey = globals.googlePlacesApiKey;
    //String BASE_TOKEN_URL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input="+query+"&key=AIzaSyBIP2JwuoMf2B52uoQ6Cu88PrkWq8oId-Y";
    //String BASE_TOKEN_URL = "http://hpie.in/hpetax/places.json";
    //String BASE_TOKEN_URL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input="+query+"&key="+placesApiKey;

    String BASE_TOKEN_URL = "https://maps.googleapis.com/maps/api/distancematrix/json?" + "origins=place_id:" + source + "&destinations=place_id:" + destination + "&key=" + placesApiKey;

    print("=======get_distance url =======" + BASE_TOKEN_URL);
    var match = {
      "queue_session": globals.userSession,
      "token": "123",
      "device": "android",
    };

    return _netUtil.get(BASE_TOKEN_URL,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        encoding: Encoding.getByName("utf-8")).then((dynamic res) {

      print("=======destination data=======");
      //print(res["rows"]);
      print(res["rows"][0]["elements"][0]["distance"]["value"]);
      print("=======destination data=======");
      //var results = Epayment.fromJson(res["Result"]);
      return res;
      /*
      var results = new SearchplacesModel.searchResult(res["predictions"]);

      print("=======places data=======");
      print("Description at 0" + results.list[0].description);
      print("=======places data=======");

      //results.status = 200;
      return results.list;
      */
    });
  }

  Future<ChallanitemModel> challan_list(String query) {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL2 + "tax_challan_list/get-list";

    var match = {
      "search_query": query,
      "token": "123",
      "device": "android",
    };

    return _netUtil.post(BASE_TOKEN_URL,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: json.encode(match),
        encoding: Encoding.getByName("utf-8")).then((dynamic res) {
      /*
      print("=======list que after insert=======");
      print(res);
      print("=======list que after insert=======");
      */
      var results = new ChallanitemModel.searchResult(res["Result"]);

      print("=======results=======");
      print(results);
      print("=======results=======");

      results.status = 200;
      return results;
    });
  }
}