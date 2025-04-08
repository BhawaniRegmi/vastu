import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:logistics/reusable/SignatureboxOutline.dart';
import 'package:logistics/reusable/custombutton.dart';
import 'package:logistics/signature/signature_presenter.dart';
import 'package:logistics/utils/color.dart';
import 'package:signature/signature.dart';

import '../scan.dart';

class SignScreen extends StatefulWidget {
  SignScreen(
      {Key key,
      this.trackingId,
      this.collectedAmount,
      this.status,
      this.id,
      this.weight,
      this.remarks})
      : super(key: key);
  final String trackingId;
  final String collectedAmount;
  final String status;
  final int id;
  final String remarks;
  final String weight;

  @override
  _SignState createState() => _SignState();
}

class _SignState extends State<SignScreen> implements SignatureContract {
final TextEditingController weightController = TextEditingController();

  BuildContext _ctx;
  SignaturePresenter _presenter;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool _isAlreadyClicked = false;

  _SignState() {
    _presenter = new SignaturePresenter(this);
  }
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.red,
    exportBackgroundColor: Colors.blue,
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print('Value changed'));
  }

  String formattedDate() {
    DateTime dateTime = DateTime.now();
    String dateTimeString = 'Signature_' +
        dateTime.year.toString() +
        dateTime.month.toString() +
        dateTime.day.toString() +
        dateTime.hour.toString() +
        ':' +
        dateTime.minute.toString() +
        ':' +
        dateTime.second.toString() +
        ':' +
        dateTime.millisecond.toString() +
        ':' +
        dateTime.microsecond.toString();
    return dateTimeString;
  }

  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/Signature.png');
  }

  Future<File> writeFile() async {
    final file = await _localFile;
    final Uint8List data = await _controller.toPngBytes();
    // Write the file.
    file.writeAsBytesSync(data.buffer.asInt8List());
  }

  @override
  Widget build(BuildContext context) {
    var trackNextBtn = CustomButton(
      buttonText: "Save",
      onPressed: () async {
        if (_controller.isNotEmpty && !_isAlreadyClicked) {
          _isAlreadyClicked = true;
          writeFile();
          setState(() {
            _isLoading = true;
          });
          //earlier milliseconds: 500
          Future.delayed(const Duration(milliseconds: 500), () async {  
          print("signaturenew");
          print(widget.trackingId);
          print(widget.status);
          print(widget.id.toString());
          print(widget.remarks);
          print(widget.collectedAmount);
            await _presenter.changeStatusToDelivery(
              widget.trackingId,
              widget.status,
              widget.id,
              widget.remarks,
              widget.collectedAmount,
              await _localFile,
            );
          });
        }
      },
    );
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Center(
                child: GestureDetector(
              onTap: () {
                _controller.clear();
              },
              child: Container(
                height: 18,
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Text("Clear",
                    style:
                        TextStyle(color: MyColors.darkGreyText, fontSize: 16),
                    textAlign: TextAlign.center),
              ),
            ))
          ],
          title: Text("Customer Sign",
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
        body: _isLoading
            ? new Center(
                child: new CircularProgressIndicator(
                backgroundColor: MyColors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ))
            : Container(
                color: MyColors.white,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 48, 0, 48),
                        child: Text("Please sign within this area.",
                            style: TextStyle(
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w400,
                                color: MyColors.darkGreyText,
                                fontSize: 14))),
                    Container(
                      height: 300,
                      width: 300,
                      child: Signature(
                        controller: _controller,
                        height: 300,
                        backgroundColor: Colors.white,
                      ),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: SignatureboxOutline(
                            borderColor: MyColors.ligtGreyText,
                            borderRadius: 0,
                            borderLength: 30,
                            borderWidth: 5,
                            cutOutSize: scanArea),
                      ),
                    ),
                  ],
                )),
        bottomNavigationBar: trackNextBtn
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  @override
  void onDetailGetError(String errorTxt) {
    _isAlreadyClicked = false;
    setState(() {
      _isLoading = false;
    });
    _showErrorDialog(errorTxt);
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
            content: Container(
              child: new Column(
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
                  ),
                  Container(
                    color: MyColors.scanDivider,
                    height: 1,
                  ),
                  new TextButton(
                    child: new Text(
                      "OK",
                      style: TextStyle(color: MyColors.primaryColor),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ));
      },
    );
  }

  @override
  void onDetailGetSuccess(String success) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            insetPadding: EdgeInsets.all(16),
            contentPadding: EdgeInsets.fromLTRB(0, 16, 0, 0),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            content: Container(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 6, 16, 16),
                    child: Text(
                      success,
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w700,
                          color: MyColors.ligtBlack,
                          fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    color: MyColors.scanDivider,
                    height: 1,
                  ),


            // TextFormField(
            //   controller: weightController,
            //   keyboardType: TextInputType.number,
            //   decoration: InputDecoration(
            //     labelText: 'Enter your weight (kg)',
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            SizedBox(height: 20),
                  new TextButton(
                    child: new Text(
                      "OK",
                      style: TextStyle(color: MyColors.primaryColor),
                    ),
                    onPressed: () {
                //                       String weight = weightController.text;
                // if (weight.isNotEmpty) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(content: Text('Weight: $weight kg')),
                //   );
                // } else {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(content: Text('Please enter a valid weight')),
                //   );
                // }
                      Navigator.of(context).pop();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QRViewExample()),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ],
              ),
            ));
      },
    );
  }
}
