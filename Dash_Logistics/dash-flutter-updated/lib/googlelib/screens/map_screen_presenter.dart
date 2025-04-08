import 'dart:convert';

import 'package:async/async.dart';
import 'package:geocode/geocode.dart';

import 'package:geolocator/geolocator.dart';
import 'package:logistics/api/editapi.dart';
import 'package:logistics/googlelib/models/geometry.dart';
import 'package:logistics/googlelib/models/location.dart';
import 'package:logistics/googlelib/models/place.dart';
import 'package:logistics/googlelib/services/geolocator_service.dart';
import 'package:logistics/googlelib/services/places_service.dart';

abstract class MapScreenContract {
  void onAddressSuccess(Address address);
  void onError(String errorTxt);
  void setCurrentLocation(Position currentLocation);
  void setLocationOnMap(Address address);
}

class MapScreenPresenter {
  MapScreenContract _view;
  Address address;
  final placesService = PlacesService();
  final geoLocatorService = GeolocatorService();
  EditApiService editApiService = new EditApiService();
  Position currentLocation;
  Place selectedLocationStatic;

  MapScreenPresenter(this._view);

  dogetAddress(double lat, double lng) async {
    try {
      Address response = await editApiService.getAddress(lat, lng);

      _view.onAddressSuccess(response);
    } catch (e) {
       print("map screen presenter presenter");
        print(e);
      _view.onError("something went wrong");
    }
  }

  doGetCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    selectedLocationStatic = Place(
      name: null,
      geometry: Geometry(
        location: Location(
            lat: currentLocation.latitude, lng: currentLocation.longitude),
      ),
    );
    _view.setCurrentLocation(currentLocation);

    getAddress(currentLocation.latitude, currentLocation.longitude);
  }

  getAddress(double lat, double lng) async {
    address = await placesService.getAddress(lat, lng);
    _view.setLocationOnMap(address);
  }
}
