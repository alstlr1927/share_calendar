// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      uid: json['uid'] == null ? '' : DataUtils.parseString(json['uid']),
      userId:
          json['user_id'] == null ? '' : DataUtils.parseString(json['user_id']),
      username: json['name'] == null ? '' : DataUtils.parseString(json['name']),
      profileImg: json['profile_image'] == null
          ? ''
          : DataUtils.parseString(json['profile_image']),
      gender: json['gender'] == null
          ? UserGender.NONE
          : DataUtils.parseUserGender(json['gender']),
      friendList: json['friend_ids'] == null
          ? const []
          : DataUtils.parseListString(json['friend_ids']),
      createdAt: DataUtils.parseDateTime(json['created_at']),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'user_id': instance.userId,
      'profile_image': instance.profileImg,
      'name': instance.username,
      'gender': _$UserGenderEnumMap[instance.gender]!,
      'friend_ids': instance.friendList,
      'created_at': instance.createdAt?.toIso8601String(),
    };

const _$UserGenderEnumMap = {
  UserGender.MALE: 'MALE',
  UserGender.FEMALE: 'FEMALE',
  UserGender.NONE: 'NONE',
};
