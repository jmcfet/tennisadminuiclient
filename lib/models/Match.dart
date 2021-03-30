import 'package:json_annotation/json_annotation.dart';
//https://flutter.dev/docs/development/data-and-backend/json#serializing-json-inside-model-classes
//flutter  pub run build_runner build
part 'Match.g.dart';

@JsonSerializable(nullable: false)


class Match{
  int id;
  int month;
  int day;
  int level;
  String Captain;
  List<String> players;

  Match({this.id,this.month,this.day,this.level,this.Captain,this.players});

  factory Match.fromJson(Map<String, dynamic> json) =>
      _$MatchFromJson(json);
  Map<String, dynamic> toJson() => _$MatchToJson(this);

}