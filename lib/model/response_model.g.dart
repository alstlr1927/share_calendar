// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseModel _$ResponseModelFromJson(Map<String, dynamic> json) =>
    ResponseModel(
      originJson: json['originJson'] as Map<String, dynamic>? ?? const {},
      code: (json['code'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      errorMsg: json['errorMsg'] as String?,
      error: json['error'] == null
          ? null
          : ErrorBean.fromJson(json['error'] as Map<String, dynamic>),
    )
      ..page = (json['page'] as num?)?.toInt()
      ..count = (json['count'] as num?)?.toInt();

Map<String, dynamic> _$ResponseModelToJson(ResponseModel instance) =>
    <String, dynamic>{
      'originJson': instance.originJson,
      'code': instance.code,
      'total': instance.total,
      'page': instance.page,
      'count': instance.count,
      'errorMsg': instance.errorMsg,
      'error': instance.error,
    };

ErrorBean _$ErrorBeanFromJson(Map<String, dynamic> json) => ErrorBean(
      errorMessage: json['errorMessage'] as String? ?? '',
      errorCode: (json['errorCode'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ErrorBeanToJson(ErrorBean instance) => <String, dynamic>{
      'errorMessage': instance.errorMessage,
      'errorCode': instance.errorCode,
    };
