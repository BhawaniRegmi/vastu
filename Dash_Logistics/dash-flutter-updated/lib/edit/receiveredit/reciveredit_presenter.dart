

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logistics/api/editapi.dart';
import 'package:logistics/response/PackageDetailM.dart';
import 'package:logistics/response/location.dart';
import 'package:logistics/response/error.dart';


abstract class EditReceiverScreenContract {
  void onEditSuccess(String message);

  void onError(String errorTxt);
  void onDetailGetSuccess(PackageDetailM detail ,List<Location> status);

}

class EditReceiverScreenPresenter {
  EditReceiverScreenContract _view;
  EditApiService editApiService = new EditApiService();

  EditReceiverScreenPresenter(this._view);

  doEditReceiver(String clinet,String code,String name,String contact,String alternateContact,
      String lat ,String lng ,String address,String landmark ,int locationId) async{
    if(address.isEmpty)
      _view.onError("Address is empty");
    else if(name.isEmpty)
      _view.onError("Name is empty");
   else if(contact.isEmpty)
      _view.onError("Contact is empty");

    else if(contact.length!=10)
      _view.onError("Contact is invalid");

    else if(alternateContact.isNotEmpty && alternateContact.length!=10)
      _view.onError("Alternate Contact is invalid");

    else if(landmark.isEmpty && clinet=="no") {
      _view.onError("Landmark is empty");
    }

    else {
      try {
        var response = await editApiService.editReceiverDetail(
            code,
            name,
            contact,
            alternateContact,
            lat,
            lng,
            address,
            landmark,
            locationId);
        if (response is String)
          _view.onEditSuccess("Update successful");

        else if(response is List<Error>){
          _view.onError(response.first.detail ?? "");
        }
        else{
           print("reciver presenter1");
        
          _view.onError("Something went wrong");

        }
      }
      catch (e) {
         print("reciver presenter2");
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

    }
    catch (e) {
       print("reciver presenter 3");
        print(e);
      _view.onError("Something went wrong");
    }
  }
}