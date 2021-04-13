// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MatchDTO1.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchDTO _$MatchDTOFromJson(Map<String, dynamic> json) {
  return MatchDTO(
      id: json['id'] as int,
      month: json['month'] as int,
      day: json['day'] as int,
      level: json['level'] as int);
   //   players: json['players'] as String);
}

Map<String, dynamic> _$MatchDTOToJson(MatchDTO instance) => <String, dynamic>{
  'id': instance.id,
  'month': instance.month,
  'day': instance.day,
  'level': instance.level,
  'players': instance.players
};
