import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:developer';
import 'dart:math' hide log;
import 'package:flutter/material.dart';
import 'package:galli_vector_plugin/galli_vector_plugin.dart';
import 'package:logistics/galliMap/galliMain.dart';

  Line _selectedLine;

class Routes extends StatefulWidget {
  // const Routes({Key key}) : super(key: key);
   const Routes() ;

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
String locationString;
    GalliSearchWidget galliSearchWidget=GalliSearchWidget();
     VectorMap  vectorMap = VectorMap();
 GalliMapController controller;
   LatLng destination;
    bool isStyleLoaded = false;
    String SearcchedPlace;
   LatLng source;
   Future<GalliMarker> _selectedMarker;
  GalliMethods methods = GalliMethods( "52b26d08-c5e7-4f18-81ac-c5432a9d8a99");
  List<Marker> markers = [];
  LatLng myLocation;
  String currentLocationName;
   void Function() clearMarkers;


 void _showTopSnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 85.6, // Position at the top
        left: 0,
        right: 0,
        child: Material(
          elevation: 10,
          child: Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.blue,
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    
    // Automatically remove the SnackBar after a delay
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }



     void _calculateRoute() async{

    if (source != null && destination != null) {

          var paths=await methods.getRoute(
	source: source,
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



  // var distanceCal1=distance/1000.toString();
  // var durationCal1=duration/60.toString();

//        ScaffoldMessenger.of(context).showSnackBar(
//   SnackBar(
//     duration:  Duration(seconds: 4),
//     content: Text('Distance ${distance/1000} KM  and   Time ${duration/60} Min by driving '),
//   ),
// );

//RouteInfoDisplay(distance: distanceCal1,duration:durationCal1 ,);

// Add marker using new coordinates
_selectedMarker = controller.addGalliMarker(GalliMarkerOptions(
  geometry: destination, // Use the new calculated coordinates
  iconAnchor: 'center',
  iconSize: 1.5,
  iconHaloBlur: 5,
  iconHaloWidth: 4,
  iconOpacity: 0.9,
  iconOffset: Offset(0, 0.5),
  iconColor: '#FF5733',
  iconHaloColor: '#FFFFFF',
  iconImage: 'assets/images/active_path.png',
  draggable: false,
));


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

        controller.animateCamera(CameraUpdate.newLatLng(source),
            duration: const Duration(milliseconds: 500));

    }
  }

  getCurrentLocation()async{
     myLocation =await controller.requestMyLocationLatLng();
     source=myLocation;
     _calculateRoute();
  }

     void getLocationName() async {
//  GalliMapController controller = GalliMapController();
print("getLocationName is called **********************");
SearcchedPlace=vectorMap.searchedPlacenew;
print("searched place is **********************:${SearcchedPlace.toString()}");
}





   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[ GalliMap(
          showCurrentLocation: true,
          authToken: "52b26d08-c5e7-4f18-81ac-c5432a9d8a99",
          size:Size (
            height: MediaQuery.of(context).size.height * 2,
            width: MediaQuery.of(context).size.width * 2,
          ),
          compassPosition:CompassView (
            position: CompassViewPosition.topRight,
            offset: const Point(32, 82)
          ),
          showCompass: true,
          showSearchWidget: false,


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

            },
          
          onMapCreated: (newC) {
            controller = newC;
            setState(() {
              if(vectorMap.latlngnew!=null){ print("latlng new on setstate*************************************************************");

              destination=vectorMap.latlngnew;
               print("destiantion*************************************************************:${destination.toString()}");
                getLocationName();
              }
            });      
          },
        ),

              Positioned(
        top: 70,
        left: 20,
        right: 20,
        child:  GalliSearchWidget(hint:vectorMap.searchedPlacenew??"Choose destination" ,authToken:  "52b26d08-c5e7-4f18-81ac-c5432a9d8a99",
         mapController: controller, onLocationSelected: (LatLng destinationLocation) {
setState(() {
              if(destination==null)
    {print("destination location is***********************:${destinationLocation.toString()}");
      destination=destinationLocation;}
    else if(destination==vectorMap.latlngnew) {
destination=destinationLocation;
    }
    else{destination=vectorMap.latlngnew;}
    _calculateRoute();
});

  },)
      ),
          
        Positioned(
        top: 28,
        left: 2,
        right: 400,
        child:  IconButton(
            icon: Icon(Icons.location_searching),
            color: Colors.red,
            iconSize: 30.0,
            onPressed: () {
               print ("destination location button pressed****************************************************");
              // Add your onPressed code here!
               
            },
          ),
      ), 
         Positioned(
          top: 12,
          left: 20,
          right: 20,
          child:  GalliSearchWidget(hint:"Choose starting point",authToken:  "52b26d08-c5e7-4f18-81ac-c5432a9d8a99",
           mapController: controller, onLocationSelected: (LatLng sourceLocation) {
print("source location is***********************:${sourceLocation.toString()}");
 source=sourceLocation;
    _calculateRoute();


  },)
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
                icon: const Icon(Icons.directions),
                color: Colors.blue,
                iconSize: 30,
                onPressed: () async {
                  // Handle route button click
               log("Get Directions button pressed");
               print("Direction button pressed");

source=await controller.requestMyLocationLatLng();
    if (source != null && destination != null) {
          var paths=await methods.getRoute(
	source: source,
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
                                 if(_selectedMarker!=null){
                    await controller.clearGalliMarkers();
                   }
// Add marker using new coordinates
_selectedMarker = controller.addGalliMarker(GalliMarkerOptions(
  geometry: destination, // Use the new calculated coordinates
  iconAnchor: 'center',
  iconSize: 1.5,
  iconHaloBlur: 5,
  iconHaloWidth: 4,
  iconOpacity: 0.9,
  iconOffset: Offset(0, 0.5),
  iconColor: '#FF5733',
  iconHaloColor: '#FFFFFF',
  iconImage: 'assets/images/active_path.png',
  draggable: false,
));

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
   controller.animateCamera(CameraUpdate.newLatLng(source),
            duration: const Duration(milliseconds: 500));
    }
                },
              ),
            ),
          ),
              Positioned(
        top: 90,
        left: 2,
        right: 400,
        child:  IconButton(
            icon: Icon(Icons.near_me),     
            color: Colors.red,
            iconSize: 30.0,
            onPressed: () {
              print ("current location button pressed");
              // Add your onPressed code here!
               
            },
          ),
      ), 
        ]
      ),
    );
  }
}
