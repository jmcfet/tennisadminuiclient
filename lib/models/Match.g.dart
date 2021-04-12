// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Match _$MatchFromJson(Map<String, dynamic> json) {
  return Match(
      id: json['id'] as int,
      month: json['month'] as int,
      day: json['day'] as int,
      level: json['level'] as int,
      Captain:json['Captain'] as String,
      players: json['players'] as List<String>);
}

Map<String, dynamic> _$MatchToJson(Match instance) => <String, dynamic>{
  'id': instance.id,
  'month': instance.month,
  'day': instance.day,
  'level': instance.level,
  'Captain' :instance.Captain,
  'players': instance.players
};
