import 'package:geocode/geocode.dart';
import 'package:logistics/googlelib/models/place.dart';
import 'dart:convert' as convert;

import 'package:logistics/googlelib/models/place_search.dart';

class PlacesService {
  final key = 'AIzaSyBIrmX0GyX_lWOXNCDTWGn3XIS6MZSBsek';

  Future<Address> getAddress(double lat, double lng) async {
    GeoCode geoCode = GeoCode();
    var addresses =
        await geoCode.reverseGeocoding(latitude: lat, longitude: lng);
    var first = addresses;
    return first;
  }
}
