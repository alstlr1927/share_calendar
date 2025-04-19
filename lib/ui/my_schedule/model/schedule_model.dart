import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../util/data_utils.dart';

part 'schedule_model.g.dart';

enum ScheduleTheme {
  RED(Color(0xFFFFe6e7), Color(0xFFdc6982)),
  VIOLET(Color(0xffece5ff), Color(0xFF7C6BFF)),
  TURQUOISE(Color(0xFFd8f9f5), Color(0xFF6bc6c7)),
  BROWN(Color(0xFFfeecde), Color(0xFF98713e)),
  WHITE(Color(0xffffffff), Color(0xff000000));

  const ScheduleTheme(this.backColor, this.textColor);

  final Color backColor;
  final Color textColor;
}

@JsonSerializable()
class ScheduleModel {
  @JsonKey(name: 'id', fromJson: DataUtils.parseString)
  final String id;

  @JsonKey(name: 'title', fromJson: DataUtils.parseString)
  final String title;

  @JsonKey(name: 'type', fromJson: DataUtils.parseString)
  final String type;

  @JsonKey(name: 'content', fromJson: DataUtils.parseString)
  final String content;

  @JsonKey(name: 'theme', fromJson: DataUtils.parseScheduleTheme)
  final ScheduleTheme theme;

  @JsonKey(name: 'owner_user_id', fromJson: DataUtils.parseString)
  final String ownerUserId;

  @JsonKey(name: 'member_ids', fromJson: DataUtils.parseMembersString)
  final List<String> memberIds;

  @JsonKey(name: 'location', fromJson: DataUtils.parseString)
  final String location;

  @JsonKey(name: 'latitude', fromJson: DataUtils.parseDouble)
  final double latitude;

  @JsonKey(name: 'longitude', fromJson: DataUtils.parseDouble)
  final double longitude;

  @JsonKey(name: 'start_date', fromJson: DataUtils.parseDateTime)
  final DateTime startDate;

  @JsonKey(name: 'end_date', fromJson: DataUtils.parseDateTime)
  final DateTime endDate;

  @JsonKey(name: 'created_at', fromJson: DataUtils.parseDateTime)
  final DateTime createdAt;

  @JsonKey(name: 'updated_at', fromJson: DataUtils.parseDateTime)
  final DateTime updatedAt;

  @JsonKey(name: 'is_able', fromJson: DataUtils.parseBoolean)
  final bool isAble;

  @JsonKey(name: 'is_complete', fromJson: DataUtils.parseBoolean)
  final bool isComplete;

  ScheduleModel({
    required this.id,
    required this.title,
    required this.type,
    required this.content,
    required this.theme,
    required this.ownerUserId,
    required this.memberIds,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.isAble,
    required this.isComplete,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleModelToJson(this);

  ScheduleModel copyWith({
    String? id,
    String? title,
    String? type,
    String? content,
    ScheduleTheme? theme,
    List<String>? imageList,
    String? ownerUserId,
    List<String>? memberIds,
    String? location,
    double? latitude,
    double? longitude,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isAble,
    bool? isComplete,
  }) =>
      ScheduleModel(
        id: id ?? this.id,
        title: title ?? this.title,
        type: type ?? this.type,
        content: content ?? this.content,
        theme: theme ?? this.theme,
        ownerUserId: ownerUserId ?? this.ownerUserId,
        memberIds: memberIds ?? this.memberIds,
        location: location ?? this.location,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isAble: isAble ?? this.isAble,
        isComplete: isComplete ?? this.isComplete,
      );
}
