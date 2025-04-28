import 'package:json_annotation/json_annotation.dart';

import '../../../util/data_utils.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  @JsonKey(name: 'id', fromJson: DataUtils.parseString)
  final String id;

  @JsonKey(name: 'uid', fromJson: DataUtils.parseString)
  final String uid;

  @JsonKey(name: 'comment', fromJson: DataUtils.parseString)
  final String comment;

  @JsonKey(name: 'user_image', fromJson: DataUtils.parseString)
  final String userImage;

  @JsonKey(name: 'user_name', fromJson: DataUtils.parseString)
  final String userName;

  @JsonKey(name: 'is_able', fromJson: DataUtils.parseBoolean)
  final bool isAble;

  @JsonKey(name: 'created_at', fromJson: DataUtils.parseDateTime)
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.uid,
    required this.comment,
    required this.userImage,
    required this.userName,
    required this.isAble,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}
