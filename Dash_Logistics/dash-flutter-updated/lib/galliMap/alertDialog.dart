// import 'package:flutter/material.dart';
// import 'package:galli_vector_plugin/galli_vector_plugin.dart';

// class FirstScreen extends StatefulWidget {
//   String markPlace;
//   LatLng latLng;
//   FirstScreen({this.markPlace,Key key,this.latLng}):
  
//    super(key: key);
//   @override
//   State<FirstScreen> createState() => _FirstScreenState();
// }

// class _FirstScreenState extends State<FirstScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//         title: Text('Are you sure ${widget.markPlace} is delivered location ?'),
//         content: SizedBox(
//           width: 50, // Set the desired width
//           height: 25, // Set the desired height
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//              // Text('Are you sure ${widget.markPlace} is delivered location ?'),
//              // SizedBox(height: 18),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(); // Close the dialog
//                    Navigator.of(context).pop(); // Close the dialog
//                 },
//                 child: Text('Yes'),
//               ),
//               SizedBox(width: 30,),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(); // Close the dialog
//                 },
//                 child: Text('No'),
//               ),
//             ],
//           ),
//         ),
//       );
//   }
// }

import 'package:flutter/material.dart';

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
                        'Are you sure this is the correct location?',
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
