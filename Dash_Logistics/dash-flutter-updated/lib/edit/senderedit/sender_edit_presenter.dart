

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logistics/api/editapi.dart';
import 'package:logistics/response/PackageDetailM.dart';
import 'package:logistics/response/location.dart';
import 'package:logistics/response/error.dart';


abstract class EditSenderScreenContract {
  void onEditSuccess(String message);

  void onError(String errorTxt);
  void onDetailGetSuccess(PackageDetailM detail ,List<Location> status);

}

class EditSenderScreenPresenter {
  EditSenderScreenContract _view;
  EditApiService editApiService = new EditApiService();

  EditSenderScreenPresenter(this._view);

  doEditSender(String code,String name,String contact,String email,
      String lat ,String lng ,String address ,int locationId) async{
    if(address.isEmpty)
      _view.onError("Address is empty");
    else if(name.isEmpty)
      _view.onError("Name is empty");
    else if(contact.isEmpty)
      _view.onError("Contact is empty");
    else if(contact.length!=10)
      _view.onError("Contact is invalid");
    else if(email.isEmpty) {
      _view.onError("Email is empty");
    }
    else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)){
      _view.onError("Email is invalid");
    }

    else {
      try {
        var response = await editApiService.editSenderDetail(
            code,
            name,
            contact,
            email,
            lat,
            lng,
            address,
            locationId);
        if (response is String)
          _view.onEditSuccess("Update successful");

        else if(response is List<Error>){
          _view.onError(response.first.detail ?? "");
        }
      }
      catch (e) {
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
        _view.onError("Something went wrong");

      }

    }
    catch (e) {
      _view.onError("Something went wrong");
    }
  }
}