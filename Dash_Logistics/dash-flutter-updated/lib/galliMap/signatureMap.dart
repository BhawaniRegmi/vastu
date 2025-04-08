import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:galli_vector_plugin/galli_vector_plugin.dart';
import 'package:logistics/galliMap/alertDialog.dart';


class SignatureMap extends StatefulWidget {
  const SignatureMap({Key key}) : super(key: key);

  @override
  State<SignatureMap> createState() => _SignatureMapState();
   LatLng get latlngnew => _SignatureMapState.destination;
   String get selectedlatlng => _SignatureMapState.selectedLatLng;
}

class _SignatureMapState extends State<SignatureMap> {
 GalliMapController controller;
  GalliMethods methods = GalliMethods("token");
  List<Marker> markers = [];
 static LatLng destination;
  Future<GalliMarker>  _selectedMarker;
   void Function() clearMarkers;
   String data;
   String selectedPlace;
  static String selectedLatLng;
    
String getName(){
  if(data!=null){return data;}
  else return "Selected Marker";
}


void showDraggableDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allows the sheet to be dragged up or down
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.3, // Initial height of the dialog (30% of the screen)
        minChildSize: 0.2,     // Minimum height (20% of the screen)
        maxChildSize: 0.8,     // Maximum height (80% of the screen)
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 6,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Are you sure ${data?? "marked place"} is you delivered location?',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Yes'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('No'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: GalliMap(
            showCurrentLocation: true,
            authToken: "token",
            size:Size (
              height: MediaQuery.of(context).size.height * 2,
              width: MediaQuery.of(context).size.width * 2,
            ),
            compassPosition:CompassView (
              position: CompassViewPosition.topRight,
              offset: const Point(32, 82)
            ),
            showCompass: true,
            onMapCreated: (newC) {
              controller = newC;
              setState(() {});
            },
            onMapClick: (LatLng latLng)async {

                        destination=latLng;
                                       data =
                  await galliMapController.reverGeoCoding(latLng);
                     // destination=galliSearchWidget.latlngnew;
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

//  Navigator.of(context).push(MaterialPageRoute(
//     builder: (context) => FirstScreen(markPlace: getName()),
//   ));

//  showDialog(
//                 barrierDismissible: false,
//                 context: context,
//                 builder: (BuildContext context) {
//                   return FirstScreen(markPlace: getName(),);
//                 });


showDraggableDialog(context);

     //Navigator.pop(context);
             

              // String? data =
              //     await galliMapController!.reverGeoCoding(latLng);
            },
          ),
        ),
      ),
    );
  }
}




