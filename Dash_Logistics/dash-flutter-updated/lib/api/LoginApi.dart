import 'dart:convert';
import 'dart:io';


import 'package:dio/dio.dart';
import 'package:logistics/response/LoginM.dart';
import 'package:logistics/reusable/URLS.dart';
import 'package:logistics/reusable/Auth.dart';

class LoginApiService {

  static LoginApiService _instance = new LoginApiService.internal();
  LoginApiService.internal();
  factory LoginApiService() => _instance;


   Future<LoginResponse> login(String email,String pasword) async {
    BaseOptions options = new BaseOptions(
      baseUrl: '${URLS.BASE_URL}',
      connectTimeout:   ( Duration(milliseconds: 5000)),
      receiveTimeout:   ( Duration(milliseconds: 3000)),
        validateStatus: (status) {
          return status < 500;
        }
    );
    Dio dio = new Dio(options);
    dio.options.headers["clientId"] = "${Auth.CLIENT_ID}";
    dio.options.headers["clientSecret"] = "${Auth.CLIENT_SECRET}";

    final response = await dio.post("${URLS.BASE_URL}${URLS.LOGIN}", data: {"clientId": "${Auth.CLIENT_ID}",
      "clientSecret": "${Auth.CLIENT_SECRET}",
      "grantType": "password",
      "email": email,
      "password": pasword});
    final int statusCode = response.statusCode;

    if(statusCode == 200 || statusCode == 422 )
    {
      LoginResponse json = new LoginResponse.fromJson(response.data);
      return json;
    }

    if (statusCode < 200 || statusCode > 400 || response.data == null) {
      throw new Exception("Error while fetching data");
    }
 //   final String res = response.data;
   // return json.decode(response.data);
    LoginResponse json = new LoginResponse.fromJson(response.data);
    return json;

  }

}
