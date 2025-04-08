
import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;
import 'package:flutter/material.dart';
//import 'package:galli_map/direction.dart';
import 'package:galli_vector_plugin/galli_vector_plugin.dart';
import 'package:logistics/galliMap/direction.dart';
import 'package:logistics/utils/routes.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp();
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const VectorMap(),
//     );
//   }
// }

class VectorMap extends StatefulWidget {
  const VectorMap();

  @override
  State<VectorMap> createState() => _VectorMapState();

   LatLng get latlngnew => _VectorMapState.destination;
     String get searchedPlacenew => _VectorMapState.searchedPlace;
}

class _VectorMapState extends State<VectorMap> {
  GalliMapController controller;
  GalliMethods methods = GalliMethods("52b26d08-c5e7-4f18-81ac-c5432a9d8a99");
  List<Marker> markers = [];
  GalliMap galliMap;
  LatLng location;
  LatLng latlang;
  Line _selectedLine;
  Map<dynamic, dynamic> autoCompleteResponse;
 static String searchedPlace;

  GalliSearchWidget galliSearchWidget=GalliSearchWidget();
   GalliMarker _galiSelectedMarker;

  static LatLng destination;  

  Future<GalliMarker> _selectedMarker; // Initialize with null
  // GalliMarker _selectedMarker;

  void Function() clearMarkers;
  LatLng latlng;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // The map widget
          GalliMap(
            showSearchWidget: false,
            showCurrentLocation: true,
            authToken: "52b26d08-c5e7-4f18-81ac-c5432a9d8a99",
            size: Size(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            compassPosition: CompassView(
              position: CompassViewPosition.topRight,
              offset: const Point(32, 82),
            ),
            showCompass: true,
            onMapCreated: (newC) {
              controller = newC;
              setState(() {});
            },
            onMapClick: (LatLng latLng) async {
            
                     destination=latLng;
//                      // destination=galliSearchWidget.latlngnew;
                   if(_selectedMarker!=null){
                    await controller.clearGalliMarkers();
                   }
//                      // _selectedMarker is of type Marker, and it will hold a reference to the Marker you added to the map.

    _selectedMarker =  controller.addGalliMarker(GalliMarkerOptions(
      geometry: latLng,
      iconAnchor: 'center',
      iconSize: 1.5,
      iconHaloBlur: 10,
      iconHaloWidth: 2,
      iconOpacity: 0.9,
      iconOffset: Offset(0, 0.8),
      iconColor: '#0077FF',
      iconHaloColor: '#FFFFFF',
      iconImage: 'assets/images/active_path.png',
      draggable: false,
    ));

     Navigator.pop(context);

            },
          ),
          
          // IconButton with shadow
          Positioned(
            bottom: 20,
            right: 70,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.route_sharp),
                color: Colors.blue,
                iconSize: 30,
                onPressed: () async {
                  // Handle route button click
                  log("Get Directions button pressed");

                  
            //       Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const RouteScreen()),
            // );
            LatLng myLocation =await controller.requestMyLocationLatLng();
              //LatLng source = LatLng(27.69241, 85.33583);
  //LatLng destination = LatLng(27.697269896109496, 85.34570172447467);
  if(galliSearchWidget.latlngnew!=null)
  {destination=galliSearchWidget.latlngnew;

     _selectedMarker =  controller.addGalliMarker(GalliMarkerOptions(
      geometry: destination,
      iconAnchor: 'center',
      iconSize: 1.5,
      iconHaloBlur: 10,
      iconHaloWidth: 2,
      iconOpacity: 0.9,
      iconOffset: Offset(0, 0.8),
      iconColor: '#0077FF',
      iconHaloColor: '#FFFFFF',
      iconImage: 'assets/images/active_path.png',
      draggable: false,
    ));
    controller.animateCamera(CameraUpdate.newLatLngZoom(myLocation, 14));
  }
          var paths=await methods.getRoute(
	source: myLocation,
	destination: destination);
log(paths.toString());
paths['data']['data'][0]['latlngs'];
log(paths.toString());
log("custom path is :${paths.toString()}");
print("custom path paths['data']['data'][0]['latlngs'] :${paths['data']['data'][0]['latlngs'].toString()}");
log("custom path paths['data']['data'][0]['latlngs'] :${paths['data']['data'][0]['latlngs'].toString()}");
print("custom path is :${paths.toString()}");
print("single latlang :${ paths['data']['data'][0]['latlngs'][0].toString()}");




List<dynamic> coordinates=paths['data']['data'][0]['latlngs'];
  List<LatLng> latLngList = coordinates.map((coord) {
    return LatLng(coord[1], coord[0]);  // LatLng(latitude, longitude)
  }).toList();


     var routeData = paths['data']['data'][0];
  var distance = routeData['distance'];

  var duration = routeData['duration'];

       ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    duration:  Duration(seconds: 3),
    content: Text('Distance ${distance/1000} KM  and   Time ${duration/60} Min by driving '),
    
  ),
);



  setState(() {
    if(_selectedLine!=null)
  controller.removeLine(_selectedLine);
  
  
});


_selectedLine = await controller.addLine(LineOptions(
  geometry: latLngList,
  lineColor: "#4285F4", // Google's path color
  lineWidth: 8.0,       // Increased width for visibility
  lineOpacity: 0.8,     // Higher opacity for clearer visibility
  draggable: false,
  lineJoin: 'round',
  lineBlur: 2,          // Reduce blur for sharpness
  lineOffset: 0,        // Center the line
));

                },
              ),
            ),
          ),

             Positioned(
            bottom: 20,
            right: 132,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.directions),
                color: Colors.blue,
                iconSize: 30,
                onPressed: () async {   

  Map<dynamic, dynamic> response = autoCompleteResponse;
  print("autocompleteresponse*********************************:${autoCompleteResponse.toString()}");
if(autoCompleteResponse!=null){
 searchedPlace = autoCompleteResponse["name"];
  print("name*********************************:${searchedPlace.toString()}");}

  
                  Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Routes()),
            );
                },
              ),
            ),
          ),
           Positioned(
          top: 12,
          left: 20,
          right: 20,
          child:  GalliSearchWidget(onAutoCompleteResultTap: (data) { autoCompleteResponse=data;},hint:"search",authToken:  "52b26d08-c5e7-4f18-81ac-c5432a9d8a99",
           mapController: controller, onLocationSelected: (LatLng searchLocation) {
            
    destination=searchLocation;
   // _calculateRoute();
  },)
      ),
        ],
      ),
    );
  }
}
