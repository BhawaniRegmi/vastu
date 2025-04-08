

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logistics/api/editapi.dart';
import 'package:logistics/response/PackageDetailM.dart';
import 'package:logistics/response/location.dart';
import 'package:logistics/response/error.dart';


abstract class EditPackageScreenContract {
  void onEditSuccess(String message);
  void onError(String errorTxt);
  void onDetailGetSuccess(PackageDetailM detail ,List<Location> status);

}

class EditPackageScreenPresenter {
  EditPackageScreenContract _view;
  EditApiService editApiService = new EditApiService();

  EditPackageScreenPresenter(this._view);

  doEditPackage(String code,String name,String price,String weight,
      String paymentType ,String extraCharge ,String extraChargeRemarks) async{
    if(name.isEmpty)
      _view.onError("Product name is empty");
    else if(price.isEmpty)
      _view.onError("Total price is empty");
    else if(weight.isEmpty)
      _view.onError("Weight is empty");
    else if(paymentType == null)
      _view.onError("PaymentType is empty");
    // else if(collectionPrice.isEmpty)
    //   _view.onError("Collection Price is empty");


    else {
      try {
        var paymentTypekey;
        if(paymentType == "Cash On Delivery")
          paymentTypekey = "cashOnDelivery";
          else
          paymentTypekey = "pre-paid";
        var response = await editApiService.editPackageDetail(
            code,
            name,
            int.parse(price),
            double.parse(weight),
            paymentTypekey,
            extraCharge,
            extraChargeRemarks);
        if (response is String)
          _view.onEditSuccess("Update successful");

        else if(response is List<Error>){
          _view.onError(response.first.detail ?? "");
        }
      }
      catch (e) {
         print("package edit 1");
        print(e);
        _view.onError("Something went wrong");
      }
    }
  }


  doGetPackageDetailAndLocation(String code) async{
    try {
     var response = await editApiService.getPackageDetailAndLocation(code);

     if(response is List<Response>){
       var jsonResponse = response[0].data["data"];
       print(jsonResponse);
       var packagedetail = PackageDetailM.fromJson(jsonResponse);

       List jsonResponseLocation = response[1].data['data'];
       var listLocation = jsonResponseLocation.map((location) => new Location.fromJson(location))
           .toList();
       _view.onDetailGetSuccess(packagedetail,listLocation);
     }
     else if(response is List<Error>){
       _view.onError(response.first.detail ?? "");
     }
     else{
       print("package edit 2");
        
       _view.onError("Something went wrong");

     }

    }
    catch (e) {
       print("package edit 3");
        print(e);
      _view.onError("Something went wrong");
    }
  }
}