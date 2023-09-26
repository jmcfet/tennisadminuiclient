import 'package:json_annotation/json_annotation.dart';
//https://flutter.dev/docs/development/data-and-backend/json#serializing-json-inside-model-classes
//flutter  pub run build_runner build
part 'Match.g.dart';

@JsonSerializable(nullable: false)


class Match{
  int? id;
  int? year;
  int? month;
  int? day;
  int? level;
  String? Captain;
  List<String>? players;

  Match({this.id,this.year,this.month,this.day,this.level,this.Captain,this.players});

  Match.fromJSON(Map<String, dynamic> json) {

    id =  json['id'] as int ;
    month =  json['month'] as int;
    year =  json['year'] as int;
    day =  json['day'] as int;
    level =  json['level'] as int;
    var playersJSON = json['players'];
    Captain = json['Captain'] as String;
    players = new List<String>.from(playersJSON);

  }
  Map<String, dynamic> toJson() => _$MatchToJson(this);

}