import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:logistics/edit/senderedit/sender_edit_presenter.dart';
import 'package:logistics/googlelib/screens/map_screen.dart';
import 'package:logistics/packagedetailpage/package_detail_screen.dart';
import 'package:logistics/response/LoginM.dart';
import 'package:logistics/response/PackageDetailM.dart';
import 'package:logistics/response/location.dart';
import 'package:logistics/reusable/custombutton.dart';
import 'package:logistics/reusable/darkgreytext.dart';
import 'package:logistics/reusable/greytext.dart';
import 'package:logistics/reusable/greytextmeduim.dart';
import 'package:logistics/reusable/staticorangetextmeduim.dart';
import 'package:logistics/reusable/textregularsecondary.dart';
import 'package:logistics/scan.dart';
import 'package:logistics/utils/color.dart';
import 'package:shared_preferences/shared_preferences.dart';



class EditSenderScreen extends StatefulWidget {
  EditSenderScreen({Key key,this.code}) : super(key: key);

  final String code;
  @override
  _EditSenderScreenState createState() => _EditSenderScreenState();
}

class _EditSenderScreenState extends State<EditSenderScreen> implements EditSenderScreenContract{

  bool _isLoading = false;
  BuildContext _ctx;
  EditSenderScreenPresenter _presenter;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  _EditSenderScreenState() {
    _presenter = new EditSenderScreenPresenter(this);
  }

  void _showDialog(String message,bool closescreen) {
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
                        if(closescreen)
                          Navigator.pop(context, closescreen);
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

  void _submit() {
    if(detail.senderGoogleAddress==null){
      _showDialog("address is empty", false);
    }
    else {
      setState(() => _isLoading = true);
      _presenter.doEditSender(
          widget.code,
          nameController.text,
          contactController.text,
          emailController.text,
          detail.senderLatitude.toString(),
          detail.senderLongitude.toString(),
          detail.senderGoogleAddress,
          dropdownValue.id);
    }

  }
  // Clean up the controller when the widget is disposed.
  // Clean up the controller when the widget is disposed.
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();

  Location dropdownValue;
  List<Location> location;
  PackageDetailM detail;

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

  Location _getLocation(int locationId) {
    var obj = location
        .where((oldValue) => locationId == (oldValue.id))
        ;
    if(obj.isNotEmpty)
      return obj.first;
  }


  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var editname = Container(
        padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
        child: TextField(
          cursorColor: MyColors.primaryColor,
          controller: nameController,
          obscureText: false,
          textInputAction: TextInputAction.next,
          style: TextStyle(color: MyColors.darkGreyText,fontSize: 14,fontFamily: "Roboto",
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

    var editContact = Container(
        padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
        child: TextField(
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
          cursorColor: MyColors.primaryColor,
          controller: contactController,
          obscureText: false,
          textInputAction: TextInputAction.next,
          style: TextStyle(color: MyColors.darkGreyText,fontSize: 14,fontFamily: "Roboto",
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

    var editEmail = Container(
        padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
        child: TextField(
          controller: emailController,
          cursorColor: MyColors.primaryColor,
          obscureText: false,
          style: TextStyle(color: MyColors.darkGreyText,fontSize: 14,fontFamily: "Roboto",
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


    var locationDropDown =   Container(
      margin: EdgeInsets.fromLTRB(24, 8, 24, 0),

      child:
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(15, 0, 14, 0),
        child: DropdownButton<Location>(
            isExpanded: true,
            hint: Text("Select hub"),
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
            onChanged: (Location newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },

            items: this.location?.map<DropdownMenuItem<Location>>(
                    (Location value) {
                  return DropdownMenuItem<Location>(
                    value: value,
                    child: Text(value.name),
                  );
                })?.toList()),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: MyColors.lightGrey,
      ),
    );

    var location =   Container(
      margin: EdgeInsets.fromLTRB(24, 8, 24, 0),
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16),

      child:
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(0, 0, 14, 0),
        child: TextDarkGrey(text: (detail !=null && dropdownValue!=null)  ? dropdownValue.name : "",),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: MyColors.lightGrey,
      ),
    );

    var editBtn = CustomButton(
      buttonText: "Update",
      onPressed: () {
       _submit();
      },
    );
    var commonPadding = SizedBox(
      height: 16,
    );

    return Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: BackButton(
              color: Colors.black
          ),
          title: Text("Edit Sender",
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
        body: _isLoading ? new Center(child: new CircularProgressIndicator(
          backgroundColor: MyColors.white,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),))  : Container(
      color: MyColors.white,
       child: SingleChildScrollView(
            child:Container(
                color: MyColors.white,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Container(
                        padding: EdgeInsets.fromLTRB(24, 20, 18, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: SizedBox(
                                height: 17,
                                width: 18,
                                child: Image.asset("assets/images/active_path.png"),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                              child: new TextGreyMeduim(text: "Pickup Location"),
                            ),

                          ],

                        )),
                    GestureDetector(
                      onTap: () {
                        _navigateAndGetAddress(_ctx);
                      },
                      child :Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[ Container(
                       width: MediaQuery.of(context).size.width -100,

                         child: Padding(
                            padding: EdgeInsets.fromLTRB(58, 0, 0, 0),
                            child: new TextDarkGrey(text: detail !=null  ? detail.senderGoogleAddress : "Select Address from map"),
                          )),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 34, 0),
                            child: SizedBox(
                              height: 15,
                              width: 11,
                              child: Image.asset("assets/images/dark_path.png"),
                            ),
                          )


                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(54, 6, 30, 0),
                      height: 1,
                      color: MyColors.scanDivider,

                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(24, 16, 0, 0),
                      child: new TextGreyMeduim(text: "Location"),
                    ),
                    detail.client=="no" ? location : locationDropDown,
                    Padding(
                      padding: EdgeInsets.fromLTRB(24, 24, 0, 0),
                      child:  StaticTextOrangeMeduim(staticText: "SENDER DETAILS",),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(24, 16, 0, 0),
                      child: new TextGreyMeduim(text: "Full Name"),
                    ),

                    editname,
                    Padding(
                      padding: EdgeInsets.fromLTRB(24, 16, 0, 0),
                      child: new TextGreyMeduim(text: "Mobile No."),
                    ),
                    editContact,
                    Padding(
                      padding: EdgeInsets.fromLTRB(24, 16, 0, 0),
                      child: new TextGreyMeduim(text: "Email"),
                    ),
                    editEmail,
                    Container(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),

                        child: editBtn
                    )


                  ],
                )
            )
        ),)

    );
  }

  _navigateAndGetAddress(BuildContext context) async {
    var  addressGeo  = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );

    setState(() {
      detail.senderGoogleAddress = addressGeo.addressLine;
      detail.senderLatitude = addressGeo.coordinates.latitude.toString();
      detail.senderLongitude = addressGeo.coordinates.longitude.toString();

    });
  }


  @override
  void onDetailGetSuccess(PackageDetailM detail, List<Location> location) {

    setState(() {
      _isLoading = false;
      this.detail = detail;
      this.location = location;
      dropdownValue = _getLocation(detail.senderLocationId);
      setAllTextField();
    });
  }

  @override
  void onEditSuccess(String message) {
    setState(() {
      _isLoading = false;
    });
    _showDialog(message,true);

  }

  @override
  void onError(String errorTxt) {
    setState(() {
      _isLoading = false;
    });
    _showDialog(errorTxt,false);
  }
  void setAllTextField() {
    contactController..text = detail !=null  ? detail.senderContact : "";
    emailController..text = detail !=null  ? detail.email : "";
    nameController..text = detail !=null  ? detail.senderName : "";
  }

}



