import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:logistics/login/login_screen.dart';
import 'package:logistics/packagedetailpage/package_detail_screen.dart';
import 'package:logistics/reusable/custombutton.dart';
import 'package:logistics/utils/color.dart';
import 'package:shared_preferences/shared_preferences.dart';


class QRViewExample extends StatefulWidget {
  QRViewExample({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample>  with WidgetsBindingObserver{
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isScanSelected = true;
  bool isFirst = true;
  BuildContext _ctx;
  bool isDialogOpen = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller.pauseCamera();
  //   }
  //   controller.resumeCamera();
  // }

void reassemble() {
  super.reassemble();
  if (Platform.isAndroid) {
    // Remove the pauseCamera call here
    // controller.pauseCamera();
  }
  controller?.resumeCamera(); // Keep the resumeCamera call
}

  final trackCodeController = TextEditingController();

  // checkPermission() async {
  //   var status = await Permission.camera.status;
  //   if (status.isGranted) {
  //     if(isDialogOpen)
  //       Navigator.of(context).pop();
  //     setState(() {
  //       isFirst = false;
  //     });
  //   }
  //   else{
  //     _showPermissionRequirementDialog("Please provide permission to use camera for scan work."
  //         "If you have denied or ignored it, then provide from app settings and reopen the app.");
  //   }
  // }

  checkPermission() async {
  var status = await Permission.camera.status;
  if (status.isGranted) {
    if (isDialogOpen) Navigator.of(context).pop();
    setState(() {
      isFirst = false;
    });
    // Ensure camera resumes after permission is granted
    controller?.resumeCamera();
  } else {
    _showPermissionRequirementDialog(
        "Please provide permission to use camera for scan work. "
        "If you have denied or ignored it, then provide from app settings and reopen the app.");
  }
}



  askPermission() async{
    if (await Permission.camera.request().isGranted) {
      setState(() {
        isFirst = false;
      });
    }
    else{
      if (Platform.isAndroid) {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
      else {
        exit(0);
      }
    }
  }
  @override
  void initState() {
    checkPermission();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    // flutter defined function
    showDialog(
      context: context,
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

  void _showConfirmationDialog(String message) {
    // flutter defined function
    showDialog(
      context: context,
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
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(() {

                            });
                          },
                          child :  Container(
                              height: 50,
                              width: 100,
                              padding: EdgeInsets.all(16),
                              child: new Text("Cancel",  style: TextStyle(color: MyColors.primaryColor,fontFamily: "roboto",fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ))),
                      GestureDetector(
                          onTap: () {
                            setState(() {});
                            _logout();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                                  (Route<dynamic> route) => false,
                            );
                          },
                          child :  Container(
                              height: 50,
                              width: 100,
                              padding: EdgeInsets.all(16),
                              child: new Text("OK",  style: TextStyle(color: MyColors.primaryColor,fontFamily: "roboto",fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              )))
                    ],
                  ),
                ],
              ),));
      },
    );
  }

  void _showPermissionRequirementDialog(String message) {
    isDialogOpen = true;
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
                        isDialogOpen = false;
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

  void _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', "");
  }

  @override
  Widget build(BuildContext context) {
   _ctx = context;
   var qrscan = Text(
     "QR scan",
     style: TextStyle(fontFamily :"Roboto",fontWeight: FontWeight.w500,color: isScanSelected? MyColors.primaryColor : MyColors.darkGreyText,fontSize: 12),
     textAlign: TextAlign.center,
   );

   var withcode = Text(
     "Track with code",
     style: TextStyle(fontFamily :"Roboto",fontWeight: FontWeight.w500,color: isScanSelected? MyColors.darkGreyText : MyColors.primaryColor ,fontSize: 12),
     textAlign: TextAlign.center,
   );

   var editTrackingId = Container(
       padding: EdgeInsets.fromLTRB(16,8,16, 0),
       child:
       TextField(
         controller: trackCodeController,
         obscureText: false,
         style: TextStyle(color: MyColors.primaryColor),
         decoration: InputDecoration(
           contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
           hintStyle: TextStyle(color: MyColors.white),

           border: OutlineInputBorder(
             borderRadius: BorderRadius.circular(12),
             borderSide: BorderSide(
                 width: 0,
                 style: BorderStyle.none
             ),

           ),
           filled: true,
           fillColor : MyColors.lightGrey,
         ),
       )
   );

   var trackBtn = CustomButton(buttonText: "Track Order",onPressed: (){
     if(trackCodeController.text.isEmpty){
       _showErrorDialog("Tracking code must not be empty");
     }
     else {
       Navigator.push(
         _ctx,
         MaterialPageRoute(builder: (context) => PackageDetailScreen(code: trackCodeController.text,)),
       );

     }
   },);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[  

                // ElevatedButton(
                //           onPressed: () async {
                //             await controller?.resumeCamera();
                //           },
                //           child: const Text('Scan',
                //               style: TextStyle(fontSize: 20)),
                //         ),

          IconButton(
            icon: Icon(
              Icons.logout,
              color: MyColors.darkGreyText,
            ),
            onPressed: () {

              _showConfirmationDialog("Are you sure you want to logout?");

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
      body: SingleChildScrollView(
       child : Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              // The containers in the background
              new Column(
                children: <Widget>[
                  new Container(
                    height: 51,
                    color: Colors.white,
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      isScanSelected ?
                       Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: isFirst ? Container(
                          height: 0,
                          color: Colors.white,
                        ) : _buildQrView(context)):
                      Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: MyColors.blue,

                          child: Column(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  new Container(
                                    alignment: Alignment.topCenter,
                                    padding: new EdgeInsets.only(
                                        top: MediaQuery.of(context).size.height * .16,
                                        right: 32.0,
                                        left: 32.0),
                                    child: new Container(
                                      height: 213.0,
                                      width: MediaQuery.of(context).size.width,
                                      child: new Card(
                                        color: MyColors.white20,
                                        elevation: 1.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14.0)),
                                      ),
                                    ),
                                  ),
                                  new Container(
                                    alignment: Alignment.topCenter,
                                    padding: new EdgeInsets.only(
                                        top: MediaQuery.of(context).size.height * .14,
                                        right: 17.0,
                                        left: 17.0),
                                    child: new Container(
                                      height: 213.0,
                                      width: MediaQuery.of(context).size.width,
                                      child: new Card(
                                          color: MyColors.white,
                                          elevation: 1.0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(14.0)),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.fromLTRB(18,28, 0, 0),
                                                child: Text(
                                                  "Enter Tracking Code",
                                                  style: TextStyle(fontFamily :"Roboto",fontWeight: FontWeight.w500,color: MyColors.ligtGreyText,fontSize: 12),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              editTrackingId,
                                              SizedBox(height: 8),
                                              trackBtn
                                            ],
                                          )
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )

                      )

                  ],),

                ],
              ),

              new Container(
                alignment: Alignment.topCenter,
                padding: new EdgeInsets.only(
                    top: 20,
                    right: 20.0,
                    left: 20.0),
                child: new Container(
                  width: MediaQuery.of(context).size.width,
                  child: new Card(
                    color: Colors.white,
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(12.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                    new GestureDetector(
                      onTap: (){
                        setState(() {
                          isScanSelected = true;
                        });
                      },
                      child:  Container(
                          padding: EdgeInsets.fromLTRB(15,20,18, 18),
                          child : Column(
                            children: <Widget>[
                              new SizedBox(
                                height: 25,
                                child: isScanSelected ?
                                Image.asset("assets/images/activeqricon.png") : Image.asset("assets/images/qricon.png") ,
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(15, 5, 15, 10),
                               child: qrscan,
                              ),

                            ],
                          )
                        ),
                    ),

                        Container(
                          margin: EdgeInsets.fromLTRB(25, 10,0, 10),
                          color: MyColors.scanDivider,
                          width: 2,
                          height: 50,
                        ),
                  new GestureDetector(
                      onTap: (){
                        setState(() {
                          isScanSelected = false;
                        });
                        print("Container clicked");
                      },
                       child: Container(
                          padding: EdgeInsets.fromLTRB(15,20,18, 18),
                          child : Column(
                            children: <Widget>[
                              new SizedBox(
                                height: 25,
                                child: isScanSelected?
                                Image.asset("assets/images/withcode.png"):Image.asset("assets/images/active_withcode.png"),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(15, 5, 15, 10),
                                child: withcode,
                              ),

                            ],
                          ),
                        )
    ),
                      ],
                    ),

                  ),
                ),
              )
            ],
          ),
        ],
      ),),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this dash we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//        // if(!isFirst)
//        // checkPermission();
//     });

void _onQRViewCreated(QRViewController controller) {
  setState(() {
    this.controller = controller;
  });

  // Ensure camera resumes when QR view is created
  controller.resumeCamera();

  controller.scannedDataStream.listen((scanData) {
    setState(() {
      result = scanData;
      print("Scanned data is*************************************************:${result.code.toString()} ");
      print(result.code);
      controller?.stopCamera();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => PackageDetailScreen(code: result.code)),
        (Route<dynamic> route) => false,
      );
    });
  });
}


    // controller.scannedDataStream.listen((scanData) {
    //   setState(() {
    //     result = scanData;
    //     print(result.code);
    //     controller?.dispose();
    //     controller?.stopCamera();
    //     Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(builder: (context) => PackageDetailScreen(code: result.code,)),
    //           (Route<dynamic> route) => false,
    //     );
    //   });
    // });
  }





// void reassemble() {
//   super.reassemble();
//   if (Platform.isAndroid) {
//     // Remove the pauseCamera call here
//     // controller.pauseCamera();
//   }
//   controller?.resumeCamera(); // Keep the resumeCamera call
// }

// checkPermission() async {
//   var status = await Permission.camera.status;
//   if (status.isGranted) {
//     if (isDialogOpen) Navigator.of(context).pop();
//     setState(() {
//       isFirst = false;
//     });
//     // Ensure camera resumes after permission is granted
//     controller?.resumeCamera();
//   } else {
//     _showPermissionRequirementDialog(
//         "Please provide permission to use camera for scan work. "
//         "If you have denied or ignored it, then provide from app settings and reopen the app.");
//   }
// }

// void _onQRViewCreated(QRViewController controller) {
//   setState(() {
//     this.controller = controller;
//   });

//   // Ensure camera resumes when QR view is created
//   controller.resumeCamera();

//   controller.scannedDataStream.listen((scanData) {
//     setState(() {
//       result = scanData;
//       print(result.code);
//       controller?.stopCamera();
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//             builder: (context) => PackageDetailScreen(code: result.code)),
//         (Route<dynamic> route) => false,
//       );
//     });
//   });
// }
