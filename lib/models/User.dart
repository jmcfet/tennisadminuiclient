import 'package:json_annotation/json_annotation.dart';
//https://flutter.dev/docs/development/data-and-backend/json#serializing-json-inside-model-classes
//flutter  pub run build_runner build
import 'package:json_annotation/json_annotation.dart';
//https://flutter.dev/docs/development/data-and-backend/json#serializing-json-inside-model-classes
//flutter  pub run build_runner build
part 'User.g.dart';

@JsonSerializable(nullable: false)
class User{
  String? Id;
  String? Name;
  String? Email;
  String? userid;
  int? level;
  int? notused;

  int  timesCaptain = 0;


  User({this.Id,this.Email,
    this.Name,this.level,this.timesCaptain = 0,this.userid,this.notused});

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

}