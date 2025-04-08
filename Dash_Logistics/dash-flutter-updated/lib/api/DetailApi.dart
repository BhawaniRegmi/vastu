import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logistics/newChange/weightTextField.dart';
import 'package:logistics/response/PackageDetailM.dart';
import 'package:logistics/reusable/PopUp.dart';
import 'dart:developer' as developer;

import 'package:logistics/reusable/URLS.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:logistics/response/error.dart';



class DetailApiService {
  static DetailApiService _instance = new DetailApiService.internal();

  DetailApiService.internal();
  PackageDetailM detail;
  WeightInputDialog newweightobj;

  factory DetailApiService() => _instance;
  //if(newweightobj.newweight1!=''){newWeight2=newweightobj.newweight1;}
  //if(detail.finalPackageWeight==)
  //double newfinal_weight =null; 
  StatusChangePopUp o1;
  
  

  Future<dynamic> getPackageDetail(String code) async {
      
  
    BaseOptions options = new BaseOptions(
        baseUrl: '${URLS.BASE_URL}',
        //connectTimeout: 30000,
        connectTimeout:( Duration(milliseconds:30000)),
        receiveTimeout: ( Duration(milliseconds:30000)),
        validateStatus: (status) {
          return status < 500;
        }
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    // print("token");

    Dio dio = new Dio(options);
    dio.options.headers["Authorization"] = "Bearer $token";

    var response = await Future.wait([dio.get(
      '${URLS.BASE_URL}${URLS.DETAIL}$code',
    ), dio.get(
      '${URLS.BASE_URL}${URLS.STATUS_LIST}',
    )
    ,dio.get(
    '${URLS.BASE_URL}${URLS.HUB_LIST}',
    )
      ,dio.get(
      '${URLS.BASE_URL}${URLS.EMPLOYEE}',
    ),
      dio.get(
        '${URLS.BASE_URL}${URLS.PERMISSIONStatus}',
      )
    ]);
    if(response[0].statusCode != 200){
      List jsonErrorResponse =  response[0].data["errors"];
      var listError = jsonErrorResponse.map((error) => new Error.fromJson(error))
          .toList();
      return listError;
    }
    else if(response[1].statusCode != 200){
      List jsonErrorResponse = response[0].data["errors"];
      var listError = jsonErrorResponse.map((error) => new Error.fromJson(error))
          .toList();
      return listError;
    }
    else if(response[2].statusCode != 200){
      List jsonErrorResponse = response[0].data["errors"];
      var listError = jsonErrorResponse.map((error) => new Error.fromJson(error))
          .toList();
      return listError;
    }
    else if(response[3].statusCode != 200){
      List jsonErrorResponse = response[0].data["errors"];
      var listError = jsonErrorResponse.map((error) => new Error.fromJson(error))
          .toList();
      return listError;
    }
    else if(response[4].statusCode != 200){
      List jsonErrorResponse = response[0].data["errors"];
      var listError = jsonErrorResponse.map((error) => new Error.fromJson(error))
          .toList();
      return listError;
    }



    return response;
  }
  
  
  Future<dynamic> changeStatus(String trackingId,String status, int hub,String remarks,String newFinalWeight) async {
    print("detailApi1");

    FormData formData = FormData.fromMap(
        {"status": status, "hubId": hub,
          "actionRemarks": remarks, "final_weight": newFinalWeight
          //detail.finalPackageWeight
        });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    // print(token);
    BaseOptions options = new BaseOptions(
      baseUrl: '${URLS.BASE_URL}',
      connectTimeout: ( Duration(milliseconds:5000)),
      receiveTimeout: ( Duration(milliseconds:300000)),                         //erlier 3000
    );

    Dio dio = new Dio(options);
    dio.options.headers["Authorization"] = "Bearer $token";
    final response = await dio.post('employee/package/${trackingId}/status-edit?_method=PUT', data: formData);
    print(response.toString());
    if(response.statusCode != 200){
      List jsonErrorResponse =  response.data["errors"];
      var listError = jsonErrorResponse.map((error) => new Error.fromJson(error))
          .toList();
      return listError;
    }
    if(response.statusCode == 200){
        print("sucessfull for post ");
    }

print(response.toString());
    if (response.statusCode == 200) {
      print("v1");
      var jsonResponse = response.data["data"];
     // print(jsonResponse);
      var obj = PackageDetailM.fromJson(jsonResponse);
      return  obj.currentStatus;
    }   else {
      List jsonErrorResponse = response.data["errors"];
      var listError = jsonErrorResponse.map((error) => new Error.fromJson(error))
          .toList();
      return listError;
    }
  }

  // Future<dynamic> changeStatusWithFile(String trackingId, status, int hub,String remarks, String amount,File file,String finalWeight) async {
  //   var price = amount;
  //   if(price.isEmpty)
  //     price = "0";
  //   FormData formData = FormData.fromMap(
  //       {"status": status, "hubId": hub,
  //         "actionRemarks": remarks,
  //         "collectionPrice": int.parse(price),
  //         "signature":
  //        await MultipartFile.fromFile(file.path),
  //        "final_weight": finalWeight
  //       });


    Future<dynamic> changeStatusWithFile(String trackingId, status, int hub,String remarks, String amount,File file) async {
    var price = amount;
    if(price.isEmpty)
      price = "0";
    FormData formData = FormData.fromMap(
        {"status": status, "hubId": hub,
          "actionRemarks": remarks,
          "collectionPrice": int.parse(price),
          "signature":
         await MultipartFile.fromFile(file.path),
         
        });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    print(token);
    BaseOptions options = new BaseOptions(
      baseUrl: '${URLS.BASE_URL}',
      connectTimeout:  ( Duration(milliseconds:50000)),
      receiveTimeout:   ( Duration(milliseconds:30000)),
    );

    Dio dio = new Dio(options);
    dio.options.headers["Authorization"] = "Bearer $token";
    final response = await dio.post('employee/package/${trackingId}/status-edit?_method=PUT', data: formData);
print(response);
    if (response.statusCode == 200) {
      print("v2");

      var jsonResponse = response.data["data"];
      print(jsonResponse);
      var obj = PackageDetailM.fromJson(jsonResponse);
      return obj.currentStatus;
 
    }
    else {
    List jsonErrorResponse = response.data["errors"];
    var listError = jsonErrorResponse.map((error) => new Error.fromJson(error))
        .toList();
    return listError;
    }
    }


}
