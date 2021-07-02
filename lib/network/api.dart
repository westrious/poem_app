import 'package:dio/dio.dart';
import 'package:poem_app/network/config.dart';

class Api {
  static String baseUrl = Config.API_PREFIX;

  /// Default HTTP Client
  static Dio httpClientDefault = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Config.CONNECT_TIMEOUT,
      receiveTimeout: Config.RECEIVE_TIMEOUT,
    ),
  );

  /// Packge the [get] method
  static Future<Response<T>> get<T>(
    String path, {
    Dio dio,
    Map<String, dynamic> queryParameters,
    Options options,
  }) async {
    dio = dio ?? httpClientDefault;
    try {
      var response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioError catch (e) {
      print(e);
      return null;
    }
  }
}
