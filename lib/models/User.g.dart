// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  if (json != null)
  return User(
      Id: json['Id'] as String,
      Email: json['Email'] as String,
      Name: json['Name'] as String,
      level: json['level'] as int,
      timesCaptain: json['timesCaptain'] as int);
  else
    return null;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'Id': instance.Id,
      'Name': instance.Name,
      'Email': instance.Email,
      'level': instance.level,
      'timesCaptain': instance.timesCaptain
    };
