import 'package:json_annotation/json_annotation.dart';

import 'User.dart';
//https://flutter.dev/docs/development/data-and-backend/json#serializing-json-inside-model-classes
//flutter  pub run build_runner build
part 'PlayersinfoandBookedDate.g.dart';

@JsonSerializable(nullable: false)
class PlayersinfoandBookedDates{
  int? Id;
  User? user;
  int? Month;
  int? day;
  String? status;
  bool bIsCaptain;
//  int  timesCaptain;


   PlayersinfoandBookedDates ({this.Id,  this.Month,this.status,this.bIsCaptain = false,this.day,this.user});
 // ({this.Id,   this.Name,this.Month,this.status,this.timesCaptain,this.bIsCaptain,this.level,this.day,this.user});

 // factory PlayersinfoandBookedDates.fromJson(Map<String, dynamic> json) =>
 //     _$PlayersinfoandBookedDatesFromJson(json);
  //handle the embedded user object
  factory PlayersinfoandBookedDates.fromJson(Map<String, dynamic> json){
     var obj = PlayersinfoandBookedDates(
       // Id: json['Id'] as int,
        Month: json['month'] as int,
        status: json['status'] as String,
        bIsCaptain: false,
        user: User.fromJson(json['user'])
    );

    return obj;

  }
  Map<String, dynamic> toJson() => _$PlayersinfoandBookedDatesToJson(this);

}