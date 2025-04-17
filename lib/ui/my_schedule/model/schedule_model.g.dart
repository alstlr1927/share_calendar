// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleModel _$ScheduleModelFromJson(Map<String, dynamic> json) =>
    ScheduleModel(
      id: DataUtils.parseString(json['id']),
      title: DataUtils.parseString(json['title']),
      type: DataUtils.parseString(json['type']),
      content: DataUtils.parseString(json['content']),
      theme: DataUtils.parseScheduleTheme(json['theme']),
      ownerUserId: DataUtils.parseString(json['owner_user_id']),
      memberIds: DataUtils.parseMembersString(json['member_ids']),
      location: DataUtils.parseString(json['location']),
      startDate: DataUtils.parseDateTime(json['start_date']),
      endDate: DataUtils.parseDateTime(json['end_date']),
      createdAt: DataUtils.parseDateTime(json['created_at']),
      updatedAt: DataUtils.parseDateTime(json['updated_at']),
      isAble: DataUtils.parseBoolean(json['is_able']),
      isComplete: DataUtils.parseBoolean(json['is_complete']),
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
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'is_able': instance.isAble,
      'is_complete': instance.isComplete,
    };

const _$ScheduleThemeEnumMap = {
  ScheduleTheme.RED: 'RED',
  ScheduleTheme.VIOLET: 'VIOLET',
  ScheduleTheme.TURQUOISE: 'TURQUOISE',
  ScheduleTheme.BROWN: 'BROWN',
  ScheduleTheme.WHITE: 'WHITE',
};
