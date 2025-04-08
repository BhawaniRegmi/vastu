import 'package:dio/dio.dart';
import 'package:geocode/geocode.dart';

import 'package:logistics/response/PackageDetailM.dart';
import 'package:logistics/response/error.dart';
import 'package:logistics/reusable/URLS.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditApiService {
  static EditApiService _instance = new EditApiService.internal();
  EditApiService.internal();
  factory EditApiService() => _instance;

  Future<dynamic> editReceiverDetail(
      String code,
      String name,
      String contact,
      String alternateContact,
      String lat,
      String lng,
      String address,
      String landmark,
      int locationId) async {
    BaseOptions options = new BaseOptions(
        baseUrl: '${URLS.BASE_URL}',
        connectTimeout:  ( Duration(milliseconds:10000)),
        receiveTimeout:  ( Duration(milliseconds:300000)),          //erlier 3000
        validateStatus: (status) {
          return status < 500;
        });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    Dio dio = new Dio(options);
    dio.options.headers["Authorization"] = "Bearer $token";

    final response = await dio
        .put("${URLS.BASE_URL}employee/package/$code/receiver-edit", data: {
      "receiverName": name,
      "receiverContact": contact,
      "receiverAlternateNumber": alternateContact,
      "receiverLatitude": lat,
      "receiverLongitude": lng,
      "receiverNearestLandmark": landmark,
      "receiverAddress": address,
      "receiverLocationId": locationId
    });
    print(response);
    final int statusCode = response.statusCode;

    if (response.statusCode == 200) {
      print("v3");
      var jsonResponse = response.data["data"];
      print(jsonResponse);
      var obj = PackageDetailM.fromJson(jsonResponse);
      return obj.currentStatus;
    } else {
      List jsonErrorResponse = response.data["errors"];
      var listError =
          jsonErrorResponse.map((error) => new Error.fromJson(error)).toList();
      return listError;
    }
  }

  Future<dynamic> editSenderDetail(
      String code,
      String name,
      String contact,
      String email,
      String lat,
      String lng,
      String address,
      int locationId) async {
    BaseOptions options = new BaseOptions(
        baseUrl: '${URLS.BASE_URL}',
        connectTimeout:   ( Duration(milliseconds:10000)),
        receiveTimeout:  ( Duration(milliseconds:300000)),                                  //erlier 3000
        validateStatus: (status) {
          return status < 500;
        });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    Dio dio = new Dio(options);
    dio.options.headers["Authorization"] = "Bearer $token";

    final response = await dio
        .put("${URLS.BASE_URL}employee/package/$code/sender-edit", data: {
      "senderName": name,
      "senderContact": contact,
      "email": email,
      "senderLatitude": lat,
      "senderLongitude": lng,
      "senderGoogleAddress": address,
      "senderLocationId": locationId
    });
    print(response);
    final int statusCode = response.statusCode;

    if (response.statusCode == 200) {
      print("v4");
      var jsonResponse = response.data["data"];
      print(jsonResponse);
      var obj = PackageDetailM.fromJson(jsonResponse);
      return obj.currentStatus;
    } else {
      List jsonErrorResponse = response.data["errors"];
      var listError =
          jsonErrorResponse.map((error) => new Error.fromJson(error)).toList();
      return listError;
    }
  }

  Future<dynamic> editPackageDetail(
      String code,
      String name,
      int price,
      double weight,
      String paymentType,
      String extraCharge,
      String extraChargeRemarks) async {
    BaseOptions options = new BaseOptions(
        baseUrl: '${URLS.BASE_URL}',
        connectTimeout:   ( Duration(milliseconds:10000)),
        receiveTimeout:  ( Duration(milliseconds:300000)),                  //erlier 3000
        validateStatus: (status) {
          return status < 500;
        });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    Dio dio = new Dio(options);
    dio.options.headers["Authorization"] = "Bearer $token";

    final response = await dio
        .put("${URLS.BASE_URL}employee/package/$code/package-edit", data: {
      "productName": name,
      "productPrice": price,
      "finalPackageWeight": weight,
      "paymentType": paymentType,
      "extraCharge": extraCharge,
      "extraChargeRemarks": extraChargeRemarks,
    });
    print(response);
    final int statusCode = response.statusCode;

    if (response.statusCode == 200) {
      print("v5");
      var jsonResponse = response.data["data"];
      print(jsonResponse);
      var obj = PackageDetailM.fromJson(jsonResponse);
      return obj.currentStatus;
    } else {
      List jsonErrorResponse = response.data["errors"];
      var listError =
          jsonErrorResponse.map((error) => new Error.fromJson(error)).toList();
      return listError;
    }
  }

  Future<dynamic> getPackageDetailAndLocation(String code) async {
    BaseOptions options = new BaseOptions(
        baseUrl: '${URLS.BASE_URL}',
        connectTimeout:   ( Duration(milliseconds:10000)),
        receiveTimeout:   ( Duration(milliseconds:300000)),                              //erlier 3000
        validateStatus: (status) {
          return status < 500;
        });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    Dio dio = new Dio(options);
    dio.options.headers["Authorization"] = "Bearer $token";

    var response = await Future.wait([
      dio.get('${URLS.BASE_URL}${URLS.DETAIL}$code'),
      dio.get('${URLS.BASE_URL}${URLS.LOCATION}')
    ]);
    if (response[0].statusCode != 200) {
      List jsonErrorResponse = response[0].data["errors"];
      var listError =
          jsonErrorResponse.map((error) => new Error.fromJson(error)).toList();
      return listError;
    } else if (response[1].statusCode != 200) {
      List jsonErrorResponse = response[0].data["errors"];
      var listError =
          jsonErrorResponse.map((error) => new Error.fromJson(error)).toList();
      return listError;
    }

    return response;
  }

  Future<Address> getAddress(double lat, double lng) async {
    GeoCode geoCode = GeoCode();
    var addresses =
        await geoCode.reverseGeocoding(latitude: lat, longitude: lng);
    var first = addresses;
    return first;
  }
}
