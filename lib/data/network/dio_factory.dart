import 'package:clean_architecture/application/app_constants.dart';
import 'package:clean_architecture/application/app_prefs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  final AppPreferences appPreferences;
  DioFactory(this.appPreferences);
  Future<Dio> getDio() async {
    Dio dio = Dio();

    String? language = await appPreferences.getAppLanguage();
    Map<String, String> headers = {
      Constant.CONTENT_TYPE: Constant.APPLICATION_JSON,
      Constant.ACCEPT: Constant.APPLICATION_JSON,
      Constant.AUTHORIZATION: Constant.token,
      Constant.DEFAULT_LANGUAGE: language
    };

    dio.options = BaseOptions(
      headers: headers,
      baseUrl: Constant.baseUrl,
      sendTimeout: Constant.timeOut,
      receiveTimeout: Constant.timeOut,
    );

    if (!kReleaseMode) {
      // app show logs of APIs in debug mode only not in release mode
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ));
    }

    return dio;
  }
}
