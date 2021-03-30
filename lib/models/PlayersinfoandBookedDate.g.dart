part of 'PlayersinfoandBookedDate.dart';

PlayersinfoandBookedDates _$PlayersinfoandBookedDatesFromJson(Map<String, dynamic> json) {
  return PlayersinfoandBookedDates(
      Id: json['Id'] as int,
      Name: json['Name'] as String,
      Month: json['month'] as int,
      status: json['status'] as String,
      level: json['level'] as int,
      timesCaptain: json['level'] as int,
      bIsCaptain: json['isCaptain'] as bool);
}

Map<String, dynamic> _$PlayersinfoandBookedDatesToJson(PlayersinfoandBookedDates instance) => <String, dynamic>{
  'Id': instance.Id,
  'Name': instance.Name,
  'month': instance.Month,
  'status': instance.status,
//  'Email': instance.Email,
   'level': instance.level,
  'isCaptain': instance.bIsCaptain,
  'timesCaptain': instance.timesCaptain
};
