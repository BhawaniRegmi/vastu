import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logistics/galliMap/signatureMap.dart';
import 'package:logistics/reusable/staticorangetextmeduim.dart';
import 'package:logistics/reusable/textregularsecondary.dart';
import 'package:logistics/utils/color.dart';

class StatusDeliveredChangePopUp extends StatelessWidget {
  final VoidCallback onNextTap;
  final String currentStatus;
  final String newStatus;
  final String productname;
  final String price;
  final TextEditingController collectedController;
  final TextEditingController weightController;

  const StatusDeliveredChangePopUp(
      {Key key,
      this.currentStatus,
      this.newStatus,
      this.productname,
      this.price,
      @required this.collectedController,
      @required this.weightController,
      @required this.onNextTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var showError = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(14.0))),
          insetPadding: EdgeInsets.all(16),
          contentPadding: EdgeInsets.fromLTRB(25, 24, 25, 38),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          content: SingleChildScrollView(
            child: Container(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(3, 0, 3, 0),
                      height: 15,
                      width: MediaQuery.of(context).size.width,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Image.asset("assets/images/cancel.png"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(50, 16, 50, 0),
                    child: Text(
                      "Do you want to change the status from",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w700,
                          color: MyColors.ligtBlack,
                          fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 65,
                        width: 72,
                        margin: EdgeInsets.fromLTRB(3, 16, 3, 0),
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Center(
                            child: Text(
                          currentStatus,
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500,
                              color: MyColors.ligtBlack,
                              fontSize: 12),
                          textAlign: TextAlign.center,
                        )),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: MyColors.lightGrey,
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(3, 16, 3, 0),
                          height: 65,
                          width: 72,
                          child: Align(
                            alignment: Alignment.center,
                            child: Image.asset("assets/images/middivider.png"),
                          ),
                        ),
                      ),
                      Container(
                        height: 65,
                        width: 72,
                        margin: EdgeInsets.fromLTRB(3, 16, 3, 0),
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Center(
                            child: Text(
                          newStatus,
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500,
                              color: MyColors.white,
                              fontSize: 12),
                          textAlign: TextAlign.center,
                        )),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: MyColors.green,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(22, 32, 0, 20),
                        child: Text(
                          "Product Name :",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: MyColors.darkGreyText,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 32, 32, 20),
                        child: Text(
                          " $productname",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: MyColors.darkGreyText,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(22, 0, 45, 0),
                        child: Text(
                          "Product Price :",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: MyColors.ligtGreyText,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(24, 0, 32, 0),
                        child: Text(
                          "Rs $price",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: MyColors.ligtGreyText,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(22, 32, 32, 20),
                        child: Text(
                          "Collected Amount :",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: MyColors.darkGreyText,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      Container(
                          width: 150,
                          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                          child: Column(
                            children: <Widget>[
                              TextField(
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                keyboardType: TextInputType.number,
                                controller: collectedController,
                                obscureText: false,
                                style: TextStyle(color: MyColors.primaryColor),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  hintStyle:
                                      TextStyle(color: MyColors.darkGreyText),
                                  hintText: "Rs",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        width: 0, style: BorderStyle.none),
                                  ),
                                  filled: true,
                                  fillColor: MyColors.lightGrey,
                                ),
                              ),
                              showError
                                  ? TextRegularSecondary(
                                      text: "Enter collected amount",
                                    )
                                  : Container()
                            ],
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(18, 0, 25, 38),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: MyColors.primaryColor,
                ),
                onPressed: () {
                  if (collectedController.text.isNotEmpty) {
                    Navigator.of(context).pop();
                    onNextTap();
                  } else {
                    setState(() {
                      showError = true;
                    });
                  }
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(45, 15, 45, 15),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      color: MyColors.white,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
