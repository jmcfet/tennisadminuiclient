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
  final String _endpoint = "http://localhost:52175/";


  UsersDBProvider() {

  }


  Future<UsersResponse>  getUsers() async {
    UsersResponse resp = new UsersResponse();
    var response;
    Iterable list;
    var url = new Uri(scheme: 'http',
      host: 'localhost',
      port: 52175,

      path: '/api/Account/getUsers',
    );
    try {
      response = await http.get(url);
      list = json.decode(response.body);

    } catch (error, stacktrace) {
         print("Exception occured: $error stackTrace: $stacktrace");
         resp.error = error;
         return resp;
    }
    resp.users = list.map((model) => User.fromJson(model)).toList();
    return resp;
  }


  Future<BookedDatesResponse>  getMonthStatus(String month) async {
    BookedDatesResponse resp = new BookedDatesResponse();
    var response;
    Iterable list;
    var queryParameters1 = {
      'month': month

    };
    var url = new Uri(scheme: 'http',
      host: 'localhost',
      port: 52175,

      path: '/api/Account/GetMonthStatus',
      queryParameters:queryParameters1
    );
    try {
      response = await http.get(url);
      list = json.decode(response.body);

    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      resp.error = error;
      return resp;
    }
    resp.datesandstatus = list.map((model) => PlayersinfoandBookedDates.fromJson(model)).toList();
    return resp;
  }
  Future<MatchsResponse>  getAllMatchs() async {
    MatchsResponse resp = new MatchsResponse();
    var response;
    Iterable list;

    var url = new Uri(scheme: 'http',
        host: 'localhost',
        port: 52175,

        path: '/api/Account/GetAllMatchs',

    );
    try {
      response = await http.get(url);
      list = json.decode(response.body);

    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      resp.error = error;
      return resp;
    }
    List<MatchDTO> temp  = list.map((model) => MatchDTO.fromJson(model)).toList();
    resp.matches = List();
    temp.forEach((MatchDTO dto  ) {
      Match m = new Match(day:dto.day, month: dto.month, level: dto.level );
     m.players = dto.players.split(',');
     resp.matches.add(m);
    });
    return resp;
  }
  Future<UsersResponse>  saveMatches(List<Match> matches) async {
    UsersResponse resp = new UsersResponse();
    String js = jsonEncode(matches);
    var response;
    Iterable list;
    var url = new Uri(scheme: 'http',
      host: 'localhost',
      port: 52175,

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
      resp.error = e.message;
    }

    return resp;
  }
}

