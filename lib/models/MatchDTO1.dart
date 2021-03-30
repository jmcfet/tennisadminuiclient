import 'package:json_annotation/json_annotation.dart';
//https://flutter.dev/docs/development/data-and-backend/json#serializing-json-inside-model-classes
//flutter  pub run build_runner build
part 'MatchDTO.g.dart';

@JsonSerializable(nullable: false)


class MatchDTO{
  int id;
  int month;
  int day;
  int level;
  String Captain;
  String players;

  MatchDTO({this.id,this.month,this.day,this.level,this.Captain,this.players});

  factory MatchDTO.fromJson(Map<String, dynamic> json) =>
      _$MatchDTOFromJson(json);
  Map<String, dynamic> toJson() => _$MatchDTOToJson(this);

}