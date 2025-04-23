// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleModel _$ScheduleModelFromJson(Map<String, dynamic> json) =>
    ScheduleModel(
      id: json['id'] == null ? '' : DataUtils.parseString(json['id']),
      title: json['title'] == null ? '' : DataUtils.parseString(json['title']),
      type: json['type'] == null ? '' : DataUtils.parseString(json['type']),
      content:
          json['content'] == null ? '' : DataUtils.parseString(json['content']),
      theme: json['theme'] == null
          ? ScheduleTheme.VIOLET
          : DataUtils.parseScheduleTheme(json['theme']),
      ownerUserId: json['owner_user_id'] == null
          ? ''
          : DataUtils.parseString(json['owner_user_id']),
      memberIds: json['member_ids'] == null
          ? const []
          : DataUtils.parseMembersString(json['member_ids']),
      location: json['location'] == null
          ? ''
          : DataUtils.parseString(json['location']),
      latitude: json['latitude'] == null
          ? 0.0
          : DataUtils.parseDouble(json['latitude']),
      longitude: json['longitude'] == null
          ? 0.0
          : DataUtils.parseDouble(json['longitude']),
      startDate: DataUtils.parseDateTime(json['start_date']),
      endDate: DataUtils.parseDateTime(json['end_date']),
      createdAt: DataUtils.parseDateTime(json['created_at']),
      updatedAt: DataUtils.parseDateTime(json['updated_at']),
      isAble: json['is_able'] == null
          ? true
          : DataUtils.parseBoolean(json['is_able']),
    );

Map<String, dynamic> _$ScheduleModelToJson(ScheduleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'content': instance.content,
      'theme': _$ScheduleThemeEnumMap[instance.theme]!,
      'owner_user_id': instance.ownerUserId,
      'member_ids': instance.memberIds,
      'location': instance.location,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'is_able': instance.isAble,
    };

const _$ScheduleThemeEnumMap = {
  ScheduleTheme.RED: 'RED',
  ScheduleTheme.VIOLET: 'VIOLET',
  ScheduleTheme.TURQUOISE: 'TURQUOISE',
  ScheduleTheme.BROWN: 'BROWN',
  ScheduleTheme.WHITE: 'WHITE',
};
