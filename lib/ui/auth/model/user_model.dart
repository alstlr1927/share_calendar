import 'package:json_annotation/json_annotation.dart';

import '../../../util/data_utils.dart';

part 'user_model.g.dart';

enum UserGender {
  MALE('남성'),
  FEMALE('여성'),
  NONE('');

  const UserGender(this.typeKr);

  final String typeKr;
}

@JsonSerializable()
class UserModel {
  @JsonKey(name: 'uid', fromJson: DataUtils.parseString)
  final String uid;

  @JsonKey(name: 'user_id', fromJson: DataUtils.parseString)
  final String userId;

  @JsonKey(name: 'profile_image', fromJson: DataUtils.parseString)
  final String profileImg;

  @JsonKey(name: 'name', fromJson: DataUtils.parseString)
  final String username;

  @JsonKey(name: 'gender', fromJson: DataUtils.parseUserGender)
  final UserGender gender;

  @JsonKey(name: 'friend_ids', fromJson: DataUtils.parseListString)
  final List<String> friendList;

  @JsonKey(name: 'created_at', fromJson: DataUtils.parseDateTime)
  final DateTime? createdAt;

  UserModel({
    this.uid = '',
    this.userId = '',
    this.username = '',
    this.profileImg = '',
    this.gender = UserGender.NONE,
    this.friendList = const [],
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
