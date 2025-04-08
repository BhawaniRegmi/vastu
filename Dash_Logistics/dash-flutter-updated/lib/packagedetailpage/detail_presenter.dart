import 'dart:convert';
import 'dart:io';


import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:logistics/api/DetailApi.dart';
import 'package:logistics/data/rest_ds.dart';
import 'package:logistics/newChange/weightTextField.dart';
import 'package:logistics/response/PackageDetailM.dart';
import 'package:logistics/response/Permisisonstatus.dart';
import 'package:logistics/response/hub.dart';
import 'package:logistics/response/status.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logistics/response/error.dart';


abstract class PackageDetailContract {
  void onDetailGetSuccess(PackageDetailM detail, List<StatusM> status,
      List<HubM> hub, List<dynamic> allowedStatus,
      List<ForwardStatus> permissionStatus,int employeeHub);

  void onDetailGetError(String errorTxt);
  void onStatusError(String errorTxt);
  void onSessionExpired(String errorTxt);


  void onStatusChangeSuccess();
}

class PackageDetailPresenter {
WeightInputDialog newweightobj=WeightInputDialog();
  PackageDetailContract _view;
  DetailApiService detailApiService = new DetailApiService();
   PackageDetailM detail = PackageDetailM();
  


  PackageDetailPresenter(this._view);
 

   String finalWeightnew='';

   

  doChangeStatus(String trackingid,  String status, int hub,String finalWeightnew,
      String remarks) async {
        print("5th");
    try {
      print("6th");
      print(finalWeightnew);
      print(trackingid);
      print(status);
      print(hub.toString());
      print(remarks);
      print(newweightobj.newweight1);
      
           if(newweightobj.newweight1!=''){
           // detail.finalPackageWeight=newweightobj.newweight1;
           finalWeightnew=newweightobj.newweight1;
            print("detailpresenterfirst");
           }
     else {finalWeightnew=finalWeightnew;
 
 print("detailpresenter2nd");
// print(detail.finalPackageWeight);
     }
     print(finalWeightnew);
      var response = await detailApiService.changeStatus(
          trackingid, status, hub, remarks,finalWeightnew);
    print("7tgh");
          print(response);

      if (response is String)
        _view.onStatusChangeSuccess();
      else if (response is List<Error>) {
        print(response.toString());
        _view.onStatusError(response.first.detail ?? "");
      }
    }
    catch (e) {
       print("detail presenter 1");
        print(e);
      _view.onStatusError("something went wrong");
    }
  }

  doGetPackageDetail(String code) async {
    try {
     var currentTime =  DateTime.now().millisecondsSinceEpoch;
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     final int expiresIn = prefs.getInt('expireIn');
     if(currentTime > expiresIn ){
       _view.onSessionExpired("Session expire please login again!");
        return;
     }


      var response = await detailApiService.getPackageDetail(code);
      if (response is List<Response>) {
        var packagedetail = PackageDetailM.fromJson(response[0].data["data"]);

        List jsonResponseStatus = response[1].data["data"];
        var listStatus = jsonResponseStatus.map((status) =>
        new StatusM.fromJson(status)).toList();
       // listStatus.removeAt(1);

        var selectedStatus = listStatus
            .where((oldValue) =>
        packagedetail.currentStatus == (oldValue.key.toString()));
        
        Iterable<StatusM> selectedStatus1=selectedStatus;

        if (selectedStatus.isNotEmpty) {
          selectedStatus.first
              .isCurrentStatus = true;
        }

        //
        List jsonResponseHub = response[2].data["data"];
        var listHub = jsonResponseHub.map((hub) => new HubM.fromJson(hub))
            .toList();
            //jsonResponseHub.remove(1);

        var selectedHub = listHub
            .where((oldValue) => packagedetail.hubId == (oldValue.id));


        if (selectedHub.isNotEmpty) {
          selectedHub.first
              .isSelected = true;
        }
        //
         List<dynamic> allowedStatus = response[3].data["data"]['permissions'];
         int employeeHub = response[3].data["data"]['hubId'];

        List jsonforwardStatus = response[4].data["data"];
        List<ForwardStatus> permissionStatus = jsonforwardStatus.map((
            forwardStatus) => new ForwardStatus.fromJson(forwardStatus))
            .toList();
           // permissionStatus.remove(1);
       permissionStatus.remove(3);
        for (var i = 0; i < listStatus.length; i++) {
         // listStatus.remove(1);
          if (allowedStatus
              .where((oldValue) => listStatus[i].key == (oldValue))
              .isNotEmpty)
            listStatus[i].isAllowed = true;
        }
        //
        //
        // // var match = allowedStatus
        // //      .where((oldValue) => "orderConfirmed" == (oldValue)).first;
        //
        _view.onDetailGetSuccess(
            packagedetail, listStatus, listHub, allowedStatus,
            permissionStatus,employeeHub);
      }

      else if (response is List<Error>) {
        _view.onDetailGetError(response.first.detail ?? "");
      }
      else {
         print("signature presenter2");
        
        _view.onDetailGetError("Something went wrong");
      }
    }
    catch (e) {
       print("detail presenter 3");
        print(e);
      _view.onDetailGetError("Something went wrong");
    }
  }

}