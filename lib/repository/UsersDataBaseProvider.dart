import 'package:adminui/models/PlayersinfoandBookedDate.dart';
import 'package:adminui/models/UsersResponse.dart';
import 'package:adminui/models/BookedDatesResponse.dart';
import 'package:adminui/models/Match.dart';
import 'package:adminui/models/MatchDTO1.dart';
import 'package:adminui/models/MatchsResponse.dart';
import 'package:adminui/models/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
class UsersDBProvider {
 String scheme = 'https';
 int port = 443;
String server = 'landingstennis.com';

// String server = 'localhost';
// int port = 52175;

//  String scheme = 'https';
//String scheme = 'http';

/*
  String server = 'localhost';

  int port = 52175;

  String scheme = 'http';
*/

  UsersDBProvider() {

  }


  Future<UsersResponse>  getUsers() async {
    UsersResponse resp = new UsersResponse();
    var response;
    Iterable list;
    var url = new Uri(scheme: scheme,
      host: server,
      port: port,

      path: '/api/Account/getUsers',
    );
    try {
      response = await http.get(url);
      list = json.decode(response.body);

    } catch (error, stacktrace) {
         print("Exception occured: $error stackTrace: $stacktrace");
         resp.error = error.toString();
         return resp;
    }
    resp.users = list.map((model) => User.fromJson(model)).toList();
    return resp;
  }


  Future<BookedDatesResponse>  getMonthStatus(DateTime picked) async {
    BookedDatesResponse resp = new BookedDatesResponse();
    var response;
    Iterable list;
    var queryParameters1 = {
      'month': picked.month.toString(),
      'year' : picked.year.toString()

    };
    var url = new Uri(scheme: scheme,
      host: server,
      port:port,

      path: '/api/Account/GetMonthStatus',
      queryParameters:queryParameters1
    );
    try {
      response = await http.get(url);
      list = json.decode(response.body);

    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      resp.error = error.toString();
      return resp;
    }
    resp.datesandstatus = list.map((model) => PlayersinfoandBookedDates.fromJson(model)).toList();
    return resp;
  }

  Future<UsersResponse>  saveMatches(List<Match> matches) async {
    UsersResponse resp = new UsersResponse();
    String js = jsonEncode(matches);
    var response;
    Iterable list;
    var url = new Uri(scheme: scheme,
      host: server,
      port: port,

      path: '/api/Account/Matches',
    );
    try {
      final response = await http.post(
          url,
          headers: {HttpHeaders.contentTypeHeader: "application/json"},
          body: js
      );

      resp.error = '200';
      if (response.statusCode != 200) {
        resp.error = response.statusCode.toString() + ' ' + response.body;
      }
    } catch (e) {
 //     resp.error = e.e;
    }

    return resp;
  }

  Future<bool>  freezedatabase(bool state) async {

    var response;
    String list;
    var queryParameters1 = {
      'state': 'true',

    };
    //all calls to the server are now secure so must pass the oAuth token or our call will be rejected
 //   String authorization = 'Bearer ' + Globals.token;
    Map usermap;
    try {
      var url = new Uri(scheme: scheme,
          host: server,
          port: port,
          path: '/api/Account/freezedatabase',
          queryParameters:queryParameters1
      );


      response = await http.post(url
  //        headers: {HttpHeaders.authorizationHeader: authorization}

      );
  //    String test = json.decode(response.body);

    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return false;
    }

    return  true;
    //   return resp;
  }

  Future<bool>  zeroCaptainCount() async {
    var response;
    String list;

    //all calls to the server are now secure so must pass the oAuth token or our call will be rejected
    //   String authorization = 'Bearer ' + Globals.token;
    Map usermap;
    try {
      var url = new Uri(scheme: scheme,
          host: server,
          port: port,
          path: '/api/Account/zeroCaptainCounts',

      );


      response = await http.post(url
        //        headers: {HttpHeaders.authorizationHeader: authorization}

      );
 //     String test = json.decode(response.body);

    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return false;
    }

    return  true;
    //   return resp;
  }
}


