import 'package:dio/dio.dart';
import 'package:poem_app/network/api.dart';

class Method {
  static Future<Map> getToken() async {
    var url = "token";
    final result = await Api.get(
      url,
      options: Options(contentType: "application/json"),
    );
    return result?.data;
  }

  static Future<Map> getSentence(String token) async {
    var url = "sentence";
    final result = await Api.get(url,
        options: Options(
            headers: {"X-User-Token": token}, contentType: "application/json"));
    return result?.data;
  }
}
