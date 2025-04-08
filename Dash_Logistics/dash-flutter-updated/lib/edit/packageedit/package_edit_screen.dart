import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocode/geocode.dart';

import 'package:logistics/edit/packageedit/package_edit_presenter.dart';
import 'package:logistics/googlelib/screens/map_screen.dart';
import 'package:logistics/response/LoginM.dart';
import 'package:logistics/response/PackageDetailM.dart';
import 'package:logistics/response/location.dart';
import 'package:logistics/reusable/custombutton.dart';
import 'package:logistics/reusable/greytextmeduim.dart';
import 'package:logistics/reusable/staticorangetextmeduim.dart';
import 'package:logistics/scan.dart';
import 'package:logistics/utils/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPackageScreen extends StatefulWidget {
  EditPackageScreen({Key key, this.code}) : super(key: key);

  final String code;
  @override
  _EditPackageScreenState createState() => _EditPackageScreenState();
}

class _EditPackageScreenState extends State<EditPackageScreen>
    implements EditPackageScreenContract {
  bool _isLoading = false;
  BuildContext _ctx;
  EditPackageScreenPresenter _presenter;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  _EditPackageScreenState() {
    _presenter = new EditPackageScreenPresenter(this);
  }

  void _showDialog(String message, bool closescreen) {
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
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        if (closescreen) Navigator.pop(context, closescreen);
                      },
                      child: Container(
                          height: 50,
                          width: 100,
                          padding: EdgeInsets.all(16),
                          child: new Text(
                            "OK",
                            style: TextStyle(
                                color: MyColors.primaryColor,
                                fontFamily: "roboto",
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ))),
                ],
              ),
            ));
      },
    );
  }

  void _submit() {
    setState(() => _isLoading = true);
    _presenter.doEditPackage(
      widget.code,
      nameController.text,
      priceController.text,
      weightController.text,
      dropdownValue,
      extraChargeController.text,
      extraChargeRemarkContactController.text,
    );
  }

  // Clean up the controller when the widget is disposed.
  // Clean up the controller when the widget is disposed.
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final weightController = TextEditingController();
  final extraChargeRemarkContactController = TextEditingController();

  final extraChargeController = TextEditingController();
//  final collectionController = TextEditingController();
  String dropdownValue;
  PackageDetailM detail;
  Address address;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    setState(() => _isLoading = true);
    print(widget.code);
    _presenter.doGetPackageDetailAndLocation(widget.code);
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;

    var editname = Container(
        padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
        child: TextField(
          textInputAction: TextInputAction.next,
          cursorColor: MyColors.primaryColor,
          controller: nameController,
          obscureText: false,
          style: TextStyle(
              color: MyColors.darkGreyText,
              fontSize: 14,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 15.0),
            hintStyle: TextStyle(color: MyColors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
            ),
            filled: true,
            fillColor: MyColors.lightGrey,
          ),
        ));

    var editPrice = Container(
        padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
        child: TextField(
          textInputAction: TextInputAction.next,
          cursorColor: MyColors.primaryColor,
          controller: priceController..text,
          obscureText: false,
          style: TextStyle(
              color: MyColors.darkGreyText,
              fontSize: 14,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w400),
          keyboardType:
              TextInputType.numberWithOptions(signed: true, decimal: true),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 15.0),
            hintStyle: TextStyle(color: MyColors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
            ),
            filled: true,
            fillColor: MyColors.lightGrey,
          ),
        ));

    var editWeight = Container(
        padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
        child: TextField(
          textInputAction: TextInputAction.next,
          cursorColor: MyColors.primaryColor,
          controller: weightController,
          obscureText: false,
          style: TextStyle(
              color: MyColors.darkGreyText,
              fontSize: 14,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w400),
          keyboardType:
              TextInputType.numberWithOptions(signed: true, decimal: true),
          // keyboardType: TextInputType.numberWithOptions(decimal: true),

          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          // inputFormatters: <TextInputFormatter>[
          //   FilteringTextInputFormatter.digitsOnly,
          // ],
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 15.0),
            hintStyle: TextStyle(color: MyColors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
            ),
            filled: true,
            fillColor: MyColors.lightGrey,
          ),
        ));

    var editExtracharge = Container(
        padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
        child: TextField(
          textInputAction: TextInputAction.next,
          cursorColor: MyColors.primaryColor,
          controller: extraChargeController,
          obscureText: false,
          style: TextStyle(
              color: MyColors.darkGreyText,
              fontSize: 14,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w400),
          keyboardType:
              TextInputType.numberWithOptions(signed: true, decimal: true),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 15.0),
            hintStyle: TextStyle(color: MyColors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
            ),
            filled: true,
            fillColor: MyColors.lightGrey,
          ),
        ));

    var editExtraChargeRemark = Container(
        padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
        child: TextField(
          textInputAction: TextInputAction.done,
          cursorColor: MyColors.primaryColor,
          controller: extraChargeRemarkContactController,
          obscureText: false,
          style: TextStyle(
              color: MyColors.darkGreyText,
              fontSize: 14,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 15.0),
            hintStyle: TextStyle(color: MyColors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
            ),
            filled: true,
            fillColor: MyColors.lightGrey,
          ),
        ));

    // var editCollectionPrice = Container(
    //     padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
    //     child: TextField(
    //       textInputAction: TextInputAction.next,
    //       cursorColor: MyColors.primaryColor,
    //       controller: collectionController,
    //       obscureText: false,
    //       style: TextStyle(color: MyColors.darkGreyText,fontSize: 14,fontFamily: "Roboto",
    //           fontWeight: FontWeight.w400),
    //       keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
    //       inputFormatters: <TextInputFormatter>[
    //         FilteringTextInputFormatter.digitsOnly,
    //       ],
    //       decoration: InputDecoration(
    //         contentPadding: EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 15.0),
    //         hintStyle: TextStyle(color: MyColors.white),
    //         border: OutlineInputBorder(
    //           borderRadius: BorderRadius.circular(12),
    //           borderSide: BorderSide(width: 0, style: BorderStyle.none),
    //         ),
    //         filled: true,
    //         fillColor: MyColors.lightGrey,
    //       ),
    //     ));

    var paymentDropDown = Container(
        margin: EdgeInsets.fromLTRB(24, 8, 24, 0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(15, 0, 14, 0),
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text("Select payment type"),
            value: dropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.w400,
                color: MyColors.darkGreyText,
                fontSize: 14),
            underline: Container(
              height: 2,
              color: MyColors.lightGrey,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: <String>['Pre-paid', 'Cash On Delivery']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: MyColors.lightGrey,
          ),
        ));

    var editBtn = CustomButton(
      buttonText: "Update",
      onPressed: () {
        _submit();
      },
    );

    return Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: BackButton(color: Colors.black),
          title: Text("EDIT PACKAGE",
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
            : SingleChildScrollView(
                child: Container(
                    color: MyColors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 24, 0, 0),
                          child: StaticTextOrangeMeduim(
                            staticText: "PACKAGE DETAILS",
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 24, 0, 0),
                          child: new TextGreyMeduim(text: "Product Name"),
                        ),

                        editname,
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 16, 0, 0),
                          child: new TextGreyMeduim(text: "Product Weight"),
                        ),
                        editWeight,
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 16, 0, 0),
                          child: new TextGreyMeduim(text: "Price"),
                        ),
                        editPrice,
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 16, 0, 0),
                          child: new TextGreyMeduim(text: "Payment Type"),
                        ),
                        paymentDropDown,
                        // Padding(
                        //   padding: EdgeInsets.fromLTRB(24, 16, 0, 0),
                        //   child: new TextGreyMeduim(text: "Collection Price"),
                        // ),
                        // editCollectionPrice,
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 16, 0, 0),
                          child: new TextGreyMeduim(text: "Extra Charge"),
                        ),
                        editExtracharge,
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 16, 0, 0),
                          child:
                              new TextGreyMeduim(text: "Extra Charge Remarks"),
                        ),
                        editExtraChargeRemark,

                        Container(
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: editBtn)
                      ],
                    ))));
  }

  @override
  void onDetailGetSuccess(PackageDetailM detail, List<Location> location) {
    setState(() {
      _isLoading = false;
      this.detail = detail;
      dropdownValue = _getPaymentType(detail.paymentType);
      setAllTextField();
    });
  }

  String _getPaymentType(String type) {
    var tpe = ['Pre-paid', 'Cash On Delivery'];
    var obj = tpe.where((oldValue) => type == (oldValue));
    if (obj.isNotEmpty) return obj.first;
  }

  @override
  void onEditSuccess(String message) {
    setState(() {
      _isLoading = false;
    });
    _showDialog(message, true);
  }

  @override
  void onError(String errorTxt) {
    setState(() {
      _isLoading = false;
    });
    _showDialog(errorTxt, false);
  }

  void setAllTextField() {
    nameController
      ..text = (detail != null && detail.productName != null)
          ? detail.productName
          : "";
    priceController
      ..text = (detail != null && detail.productPrice != null)
          ? detail.productPrice.toString()
          : "";
    weightController
      ..text = (detail != null && detail.finalPackageWeight != null)
          ? detail.finalPackageWeight.toString()
          : "";
    extraChargeRemarkContactController
      ..text = (detail != null && detail.extraChargeRemarks != null)
          ? detail.extraChargeRemarks
          : "";
    extraChargeController
      ..text = (detail != null && detail.extraCharge != null)
          ? detail.extraCharge.toString()
          : "";
  }
}
