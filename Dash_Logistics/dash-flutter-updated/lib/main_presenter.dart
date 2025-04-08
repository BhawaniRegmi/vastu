

import 'dart:convert';
import 'dart:io';


import 'package:logistics/api/DetailApi.dart';
import 'package:logistics/data/rest_ds.dart';
import 'package:logistics/response/LoginM.dart';
import 'package:logistics/response/PackageDetailM.dart';
import 'package:logistics/response/hub.dart';
import 'package:logistics/response/status.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SplashContract {
  void isLogin(bool status);
}

class SplashPresenter {
  SplashContract _view;
  DetailApiService detailApiService = new DetailApiService();


  SplashPresenter(this._view);

  isLogin() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    print(token);
    if(token== null || token.isEmpty){
     _view.isLogin(false);

    }
    else{
      _view.isLogin(true);
    }
  }


}