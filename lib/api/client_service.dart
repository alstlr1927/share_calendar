import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_calendar/model/response_model.dart';
import 'package:couple_calendar/ui/common/components/logger/couple_logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CustomLogInterceptor extends Interceptor {
  Dio _dio;

  CustomLogInterceptor(Dio dio) : _dio = dio;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ProLog().e('req data : ${options.data}');
    // ProLog().e('req path : ${options.path}');
    // if (options.data is FormData) {
    //   ProLog().e('req qParams : ${(options.data as FormData).fields}');
    // }
    // ProLog().e('ClientService \nreq uri : ${options.uri}');

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode != 200) {
      CoupleLog().e(
          'Response [${response.statusCode}] => path: ${response.requestOptions.path}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    CoupleLog().e(
        'Error [${err.response?.statusCode}] => path: ${err.requestOptions.path}');

    super.onError(err, handler);
  }
}

class ClientService {
  ClientService._internal();

  static final ClientService _instance = ClientService._internal();

  factory ClientService() => _instance;

  Dio dio = Dio();

  final firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> getUserDb() {
    return firestore.collection('user');
  }

  CollectionReference<Map<String, dynamic>> getScheduleDb() {
    return firestore.collection('schedule');
  }

  CollectionReference<Map<String, dynamic>> getCommentDb() {
    return firestore.collection('comment');
  }

  void setInternal() async {
    dio.interceptors.clear();
    dio.interceptors.add(CustomLogInterceptor(dio));
  }

  Future<ResponseModel> getHolidayList({
    required int year,
  }) async {
    debugPrint('==================================================');
    debugPrint('sendVerifyCode\n'
        'year: $year');
    debugPrint('==================================================');

    try {
      dio.options.baseUrl = 'http://apis.data.go.kr/B090041/openapi/service';
      var qParams = {
        'solYear': year,
        'ServiceKey':
            'OkraXuKA6ND0qlzY%2BwQj9CgAEWvQ4EFqkZBfN88%2BoHYzH7arz6ra6UsozKtGEd%2FbxIvTioIt4HIDUdOdyrOLbQ%3D%3D',
        'numOfRows': 1000,
        '_type': 'json',
      };
      var response = await dio.get(
        '/SpcdeInfoService/getRestDeInfo',
        queryParameters: qParams,
      );

      CoupleLog().d('res : ${response.data}');

      var resData = {
        'originJson': response.data['response']['body']['items']['item'] ?? [],
        'code': response.statusCode,
      };

      ResponseModel res = ResponseModel.fromJson(resData);

      return res;
    } on DioException catch (e, trace) {
      CoupleLog().e('''getHolidayList
code : ${e.response?.statusCode}
data : ${e.response?.data}
error : $e''');
      CoupleLog().e('$trace');
      return ResponseModel()
        ..code = e.response?.statusCode
        ..errorMsg = e.response?.data['detail'];
    } catch (e, trace) {
      CoupleLog().e('getHolidayList\nerror : $e');
      CoupleLog().e('$trace');
      return ResponseModel()..code = -1;
    }
  }
}
