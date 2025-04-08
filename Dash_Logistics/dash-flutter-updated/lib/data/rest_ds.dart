import 'dart:async';
import 'dart:convert';

import 'package:logistics/api/LoginApi.dart';
import 'package:logistics/response/LoginM.dart';


class RestDatasource {

  LoginApiService loginApiService = new LoginApiService();

  static final BASE_URL = "https://id-api-sb.erply.com/V1/Launchpad";
  static final LOGIN_URL = BASE_URL + "/login";
  //static final _API_KEY = "somerandomkey";

  Future<LoginResponse> login(String username, String password) {
    return loginApiService.login(username,password).then((dynamic res) {
      print(res.toString());
      LoginResponse response = new LoginResponse.fromJson(res);
       return response;


  });
  }
}
