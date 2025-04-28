// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      id: DataUtils.parseString(json['id']),
      uid: DataUtils.parseString(json['uid']),
      comment: DataUtils.parseString(json['comment']),
      userImage: DataUtils.parseString(json['user_image']),
      userName: DataUtils.parseString(json['user_name']),
      isAble: DataUtils.parseBoolean(json['is_able']),
      createdAt: DataUtils.parseDateTime(json['created_at']),
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'comment': instance.comment,
      'user_image': instance.userImage,
      'user_name': instance.userName,
      'is_able': instance.isAble,
      'created_at': instance.createdAt.toIso8601String(),
    };
