import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:logistics/googlelib/models/place.dart';
import 'package:logistics/googlelib/screens/map_screen_presenter.dart';
import 'package:logistics/utils/color.dart';


class MapScreen extends StatefulWidget {
  MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver implements MapScreenContract {
  Completer<GoogleMapController> _mapController = Completer();
  final Set<Marker> _markers = {};
  CameraPosition _lastMapPosition ;
  MapScreenPresenter _presenter;
  Position currentLocation;
  Address address;
  CancelableOperation cancellableOperation;
  bool _isLoading = false;


  final scaffoldKey = new GlobalKey<ScaffoldState>();

  _MapScreenState() {
    _presenter = new MapScreenPresenter(this);
  }




  @override
  void initState() {
    checkPermission();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  checkPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (status.isGranted) {
      _presenter.doGetCurrentLocation();
    }
    else{
      _showPermissionRequirementDialog("Please provide permission to use location for retrieving address."
          "If you have denied or ignored it, then provide from app settings to make this app work better");
    }
  }

  void _updatePosition(CameraPosition _position) {
    _lastMapPosition  = _position;
    Position newMarkerPosition = Position(
        latitude: _position.target.latitude,
        longitude: _position.target.longitude);
  }

  askPermission() async{
    if (await Permission.locationWhenInUse.request().isGranted) {
      setState(() {
        _presenter.doGetCurrentLocation();
      });
    }
    else{
      Navigator.of(context).pop();
    }
  }

  Future<dynamic> fromCancelable(Future<dynamic> future) async {

  }

  void _showPermissionRequirementDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            insetPadding: EdgeInsets.all(16),
            contentPadding: EdgeInsets.fromLTRB(0, 16, 0, 0),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            content :Container(
              child :new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 6, 16, 16),
                    child: Text(
                      message,
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w700,
                          color: MyColors.ligtBlack,
                          fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),Container(
                    color: MyColors.scanDivider,
                    height: 1,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          askPermission();
                        });
                      },
                      child :  Container(
                          height: 50,
                          width: 100,
                          padding: EdgeInsets.all(16),
                          child: new Text("OK",  style: TextStyle(color: MyColors.primaryColor,fontFamily: "roboto",fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ))),],
              ),));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
              color: Colors.black
          ),
          actions: <Widget>[
            address == null ? Container():
            IconButton(
              icon: Icon(
                Icons.done,
                color: MyColors.darkGreyText,
              ),
              onPressed: ()  {
                 getAddress();
              },
            )
          ],
          title: Text("TRACK PACKAGE",
              style: TextStyle(color: MyColors.darkGreyText, fontSize: 16),
              textAlign: TextAlign.center),
          backgroundColor: MyColors.white,
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
              child: Container(
                color: MyColors.toolbarBorder,
                height: 1.0,
              ),
              preferredSize: Size.fromHeight(1.0)),

          elevation: 0,
        ),
        body: _isLoading ? Center (
        child : CircularProgressIndicator(),
        ):(address == null)
            ? Center(
                child : Column(
                  children: <Widget>[
                    SizedBox(height: 150),
                    CircularProgressIndicator(),
                  ],
               ),
              )
            :    Container(
      height: MediaQuery.of(context).size.height,
      child : Stack(children: <Widget>[
        Align(alignment: Alignment.center,
          child: GoogleMap(
            onTap: (latLng) {
            },
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                 currentLocation.latitude,
                 currentLocation.longitude),
              zoom: 14,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
            },
            onCameraMove: ((_position) => _updatePosition(_position)),

            markers: Set<Marker>.of(  <Marker>[
              // Marker(
              //   draggable: true,
              //   markerId: MarkerId("1"),
              //   position: LatLng( applicationBloc.currentLocation.latitude,    applicationBloc.currentLocation.longitude),
              //   icon: BitmapDescriptor.defaultMarker,
              //   infoWindow: const InfoWindow(
              //     title: 'Usted está aquí',
              //   ),
              // )
            ],),
          ),),

        Align(alignment: Alignment.center,
          child:SizedBox(
            child: Image.asset("assets/images/path.png"),
          )),


        Align(alignment: Alignment.bottomCenter,
            child:Container(
              child: address == null ? Text("drag map to desrire location") : Text(address.streetAddress ?? "") ,
            ))
      ],)

    ));
  }


  @override
  void onAddressSuccess(Address address) {
    Navigator.pop(context, address);
  }

  @override
  void onError(String errorTxt) {
    // TODO: implement onError
  }

  @override
  void setCurrentLocation(Position currentLocation) {
    setState(() {
      this.currentLocation = currentLocation;
    });
  }

  @override
  void setLocationOnMap(Address address) {
    setState(() {
      this.address = address;
    });

  }
  void getAddress() {
    setState(() {
      _isLoading = true;
    });
    if(_lastMapPosition!=null){
      _presenter.dogetAddress(_lastMapPosition.target.latitude ?? currentLocation.latitude,
          _lastMapPosition.target.longitude ?? currentLocation.latitude);
    }
    else
      _presenter.dogetAddress(currentLocation.latitude,
          currentLocation.longitude);
  }
}


