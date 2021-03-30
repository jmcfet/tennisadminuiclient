import 'package:json_annotation/json_annotation.dart';
//https://flutter.dev/docs/development/data-and-backend/json#serializing-json-inside-model-classes
//flutter  pub run build_runner build
part 'PlayersinfoandBookedDate.g.dart';

@JsonSerializable(nullable: false)
class PlayersinfoandBookedDates{
  int Id;
  String Name;
  int Month;
  int day;
  String status;
  int level;
  bool bIsCaptain;
  int  timesCaptain;


   PlayersinfoandBookedDates
  ({this.Id,   this.Name,this.Month,this.status,this.timesCaptain,this.bIsCaptain,this.level,this.day});

  factory PlayersinfoandBookedDates.fromJson(Map<String, dynamic> json) =>
      _$PlayersinfoandBookedDatesFromJson(json);
  Map<String, dynamic> toJson() => _$PlayersinfoandBookedDatesToJson(this);

}