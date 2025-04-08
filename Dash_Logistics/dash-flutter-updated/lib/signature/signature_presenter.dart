

import 'dart:convert';
import 'dart:io';


import 'package:logistics/api/DetailApi.dart';
import 'package:logistics/data/rest_ds.dart';
import 'package:logistics/newChange/weightTextField.dart';
import 'package:logistics/packagedetailpage/detail_presenter.dart';
import 'package:logistics/packagedetailpage/package_detail_screen.dart';
import 'package:logistics/response/error.dart';
import 'package:logistics/response/PackageDetailM.dart';
import 'package:logistics/response/hub.dart';
import 'package:logistics/response/status.dart';
import 'package:logistics/reusable/PopUp.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SignatureContract {
  void onDetailGetSuccess(String success);

  void onDetailGetError(String errorTxt);
}

class SignaturePresenter {
  SignatureContract _view;
  DetailApiService detailApiService = new DetailApiService();
  PackageDetailScreen packageDetailScreen =new  PackageDetailScreen();
  WeightInputDialog weightInputDialog =WeightInputDialog();
  PackageDetailM detail = PackageDetailM();
  StatusChangePopUp statusChangePopUp =StatusChangePopUp();
  


  SignaturePresenter(this._view);

  changeStatusToDelivery(String trackingId,String status, int hub,String remarks ,String amount ,File file) async{
      try {

        File(file.path).exists();
        print("yes yes yes");
            
        // String weight=statusChangePopUp.finalPackageWeight;
        // print(statusChangePopUp.finalPackageWeight);
         // var response = await detailApiService.changeStatusWithFile(trackingId,status,hub,remarks,amount,file,weight);
          var response = await detailApiService.changeStatusWithFile(trackingId,status,hub,remarks,amount,file);
          print(response);
        if (response is String)
       // if(response!="")
       { print("response obtained for signature sucessful");
          _view.onDetailGetSuccess("Update successful");
     
          }

        else if(response is List<Error>){
          _view.onDetailGetError(response.first.detail ?? "");
        }

      }
      catch (e) {
        print("signature presenter");
        print(e);
        _view.onDetailGetError("something went wrong");
      }
   // }
  }


}