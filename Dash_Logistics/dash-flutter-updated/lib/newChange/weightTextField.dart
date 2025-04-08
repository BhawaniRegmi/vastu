



// import 'package:flutter/material.dart';
// import 'package:logistics/response/PackageDetailM.dart';
// import 'package:logistics/reusable/PopUp.dart';

// class WeightInputDialog extends StatefulWidget {
//   @override
//   _WeightInputDialogState createState() => _WeightInputDialogState();

//   // Getter to retrieve the new weight value from the state
//   String get newweight1 => _WeightInputDialogState.newweight;
// }

// class _WeightInputDialogState extends State<WeightInputDialog> {
//   // Use static so that you can access it from the widget class
//   static String newweight = "";
   
//      // Setter
//   set newweight1(String weight) {
//     setState(() {
//       newweight = weight;  // Update the weight value and refresh the UI
//     });
//   }

//   TextEditingController _weightController = TextEditingController();
//   PackageDetailM detail=PackageDetailM();
//   StatusChangePopUp statusChangePopUp=StatusChangePopUp();

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: Colors.transparent, // Set the dialog background to transparent
//       contentPadding: EdgeInsets.zero, // Remove default padding
//       content: Container(
//         decoration: BoxDecoration(
//           color: Theme.of(context).dialogBackgroundColor, // Use app theme's background color
//           borderRadius: BorderRadius.circular(8.0), // Optional: Rounded corners
//         ),
//         padding: EdgeInsets.all(16.0), // Add padding inside the container
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Enter Weight', style: Theme.of(context).textTheme.headline6),
//             SizedBox(height: 10),
//             TextFormField(
//               controller: _weightController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 hintText: 'Enter product actual weight (kg)',
//               ),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('Cancel'),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     setState(() {
//                       newweight = _weightController.text;
                      
                      

//                     });
//                     if (newweight.isNotEmpty) {
//                       Navigator.of(context).pop();
//                     }
//                   },
//                   child: Text('Submit'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


                      import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:logistics/response/PackageDetailM.dart';
import 'package:logistics/reusable/PopUp.dart';
import 'package:logistics/reusable/URLS.dart';

class WeightInputDialog extends StatefulWidget {
  @override
  _WeightInputDialogState createState() => _WeightInputDialogState();

  // Getter to retrieve the new weight value from the state
  String get newweight1 => _WeightInputDialogState.newweight;
}

class _WeightInputDialogState extends State<WeightInputDialog> {

  StatusChangePopUp statusChangePopUp =StatusChangePopUp();
  // Use static so that you can access it from the widget class
  static String newweight = "";
   
   //  Setter
  set newweight1(String weight) {
    setState(() {
      newweight = weight;  // Update the weight value and refresh the UI
    });
  }

  TextEditingController _weightController = TextEditingController();
  PackageDetailM detail=PackageDetailM();
  String getWeight="";
  

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent, // Set the dialog background to transparent
      contentPadding: EdgeInsets.zero, // Remove default padding
      content: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor, // Use app theme's background color
          borderRadius: BorderRadius.circular(8.0), // Optional: Rounded corners
        ),
        padding: EdgeInsets.all(16.0), // Add padding inside the container
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter Weight', style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 10),
            TextFormField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter product actual weight (kg)',
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
              
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      newweight = _weightController.text;
                      getWeight=_weightController.text;
                     // statusChangePopUp.o1="Updated Weight is input";
                     // statusChangePopUp.finalPackageWeight=newweight;
                      _showTopSnackBar(context, 'New Updated Weight is: $newweight kg');





// Future<void> sendPostRequest() async {
//   // Define the API URL
//   var url = Uri.parse( '${URLS.BASE_URL}${URLS.DETAIL}${detail.trackingCode}',);

//   // Create the request body
//   Map<String, dynamic> requestBody = {
//     'finalPackageWeight': _weightController.text,
    
//   };

//   // Send the POST request
//   var response = await http.post(
//     url,
//     headers: {
//       'Content-Type': 'application/json',
//     },
//     body: jsonEncode(requestBody),
//   );

//   // Check the response status
//   if (response.statusCode == 200 || response.statusCode == 201) {
//     print('Request successful: ${response.body}');
//   } else {
//     print('Request failed: ${response.statusCode}');
//   }
// }



       


        
                //                             ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text('New Updated Weight is: $newweight kg'), duration: const Duration(seconds: 7),
      
                //   ),
                // );

                //                              ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Container(
                //   width: 300, // Set width of SnackBar
                //   padding: EdgeInsets.all(16.0),
                //   child: Text(
                //     'New Updated Weight is: $newweight kg',
                //     style: TextStyle(
                //       fontSize: 20, // Increase font size
                //       color: Colors.white,
                //     ),
                //     textAlign: TextAlign.center, // Center align text
                //   ),
                // ), duration: const Duration(seconds: 12),
                //  backgroundColor: Colors.red,
      
                //   ),
                // );
                

                    });
                    if (newweight.isNotEmpty) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



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