import 'package:logistics/galliMap/signatureMap.dart';
import 'package:logistics/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:logistics/edit/packageedit/package_edit_screen.dart';
import 'package:logistics/edit/receiveredit/receiver_edit_screen.dart';
import 'package:logistics/edit/senderedit/sender_edit_screen.dart';
import 'package:logistics/newChange/weightTextField.dart';
import 'package:logistics/response/PackageDetailM.dart';
import 'package:logistics/response/hub.dart';
import 'package:logistics/response/status.dart';
import 'package:logistics/reusable/PopUp.dart';
import 'package:logistics/reusable/darkgreytext.dart';
import 'package:logistics/reusable/delivered_popup.dart';
import 'package:logistics/reusable/greytext.dart';
import 'package:logistics/signature/signature_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../scan.dart';
import '../utils/color.dart';
import '../reusable/staticorangetextsmall.dart';
import '../reusable/custombutton.dart';
import 'detail_presenter.dart';
import 'package:logistics/response/Permisisonstatus.dart';

class PackageDetailScreen  extends StatefulWidget {
  PackageDetailScreen({Key key, this.code}) : super(key: key);

  final String code;
 // Define a GlobalKey to access the state from outside
  static final GlobalKey<_PackageDetailPage> globalKey = GlobalKey<_PackageDetailPage>();

  @override
  _PackageDetailPage createState() => _PackageDetailPage();
  
}

class _PackageDetailPage extends State<PackageDetailScreen>
    implements PackageDetailContract {

      WeightInputDialog newweightobj=WeightInputDialog();
  BuildContext _ctx;
  PackageDetailPresenter _presenter;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  _PackageDetailPage() {
    _presenter = new PackageDetailPresenter(this);
  }
SignatureMap signatureMap=SignatureMap();
  PackageDetailM detail;
String riderCurrentLatLng;
    String newWeight2 ='';

String get newWeight => newWeight2;

  _onTrackNextButton() {
    print("1234");
    setState(() {});
    if (isInitail) {
      setState(() {});


    if(newweightobj.newweight1!='')newWeight2=newweightobj.newweight1;
    else newWeight2=detail.finalPackageWeight;
   // double number1 = double.parse(newWeight2);

      
      if (autoStatusChange == "delivered") {
print("before signin screen 1**********************************************");
     Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  SignatureMap()),
            );
           if(signatureMap.latlngnew!=null){
             riderCurrentLatLng=signatureMap.latlngnew.toString();
             print("RiderCurrentLatLng***********************:${riderCurrentLatLng}");
           }

        Navigator.push(
          _ctx,
          MaterialPageRoute(
              builder: (context) => SignScreen(
                    trackingId: detail.trackingCode,
                    collectedAmount: collectedController.text,
                    status: autoStatusChange,
                    id: dropdownValue.id,
                    remarks: remarkController.text,
                  )),
        );
      } else {
        print("2nd");
        {
          setState(() {
            _isLoading = true;
          });
          _presenter.doChangeStatus(
              widget.code,
              autoStatusChange,
              isHubSelected ? dropdownValue.id : employeeHub,
               newWeight2,
              remarkController.text);
        }
      }
    } else {
      print("3rd");
      setState(() {});
         if (selectedStatus == "orderConfirmed") {
          print("before signin screen 2**********************************************");
          print("before signin screen 2**********************************************");
     Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  SignatureMap()),
            );
           if(signatureMap.latlngnew!=null){
             riderCurrentLatLng=signatureMap.latlngnew.toString();
             print("RiderCurrentLatLng***********************:${riderCurrentLatLng}");
           }
        Navigator.push(
          _ctx,
          MaterialPageRoute(
              builder: (context) => SignScreen(
                    trackingId: detail.trackingCode,
                    collectedAmount: collectedController.text ?? "",
                    status: "orderVerified",
                    id: dropdownValue.id,
                    remarks: remarkController.text ?? "",
                  )),
        );
      } 

      if (selectedStatus == "delivered") {
        print("before signin screen 3**********************************************");
        print("before signin screen 3**********************************************");
     Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  SignatureMap()),
            );
           if(signatureMap.latlngnew!=null){
             riderCurrentLatLng=signatureMap.latlngnew.toString();
             print("RiderCurrentLatLng***********************:${riderCurrentLatLng}");
           }
        Navigator.push(
          _ctx,
          MaterialPageRoute(
              builder: (context) => SignScreen(
                    trackingId: detail.trackingCode,
                    collectedAmount: collectedController.text ?? "",
                    status: selectedStatus,
                    id: dropdownValue.id,
                    remarks: remarkController.text ?? "",
                  )),
        );
      } else {
        print("4th");
        setState(() {
          _isLoading = true;
        });
        _presenter.doChangeStatus(
            widget.code,
            selectedStatus,
            isHubSelected ? dropdownValue.id : employeeHub,
            newWeight2,
            remarkController.text);
      }
    }
  }

  _onNextButton()async {
    setState(() {});
    print("before signin screen 4**********************************************");
     await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  SignatureMap()),
            );
           if(signatureMap.latlngnew!=null){
             riderCurrentLatLng=signatureMap.latlngnew.toString();
             print("RiderCurrentLatLng***********************:${riderCurrentLatLng}");
           }
    Navigator.push(
      _ctx,
      MaterialPageRoute(
          builder: (context) => SignScreen(
                trackingId: detail.trackingCode,
                collectedAmount: collectedController.text,
                status: selectedStatus,
                id: dropdownValue.id,
                remarks: remarkController.text,
              )),
    );
    print("next");
  }

  _onCancelButton() {
    setState(() {});
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => QRViewExample()),
      (Route<dynamic> route) => false,
    );
  }

  _navigateSenderAndSuccess(BuildContext context) async {
    var addressGeo = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditSenderScreen(
                code: widget.code,
              )),
    );

    if (addressGeo) _fetchData();
  }

  _navigateReceiverAndSuccess(BuildContext context) async {
    var addressGeo = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditReciverScreen(
                code: widget.code,
              )),
    );

    if (addressGeo) _fetchData();
  }

  _navigatePackageAndSuccess(BuildContext context) async {
    var addressGeo = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditPackageScreen(
                code: widget.code,
              )),
    );

    if (addressGeo) _fetchData();
  }

  _onDetailButton() {
    setState(() {
      isInitail = false;
      isFirst = false;
    });
  }

  //PackageDetailM detail;
  List<StatusM> status;
  List<HubM> hub;
  List<dynamic> allowedStatus;
  List<ForwardStatus> forwardStatus;
  String currentStatus;
  String selectedStatus;
  String autoStatusChange;
  int selectedIndex = -1;

  bool _isLoading = false;
  bool isInitail = false;
  bool isHubSelected = false;
  int employeeHub;
  bool isFirst = true;
  String finalPackageWeight="";

  @override
  void initState() {
    super.initState();
    _fetchData();
   // if(currentStatus=="Order Placed") finalPackageWeight=newweightobj.newweight1;
  
  }

  void _fetchData() {
    setState(() => _isLoading = true);
    print(widget.code);
    _presenter.doGetPackageDetail(widget.code);
  }

  void _showInitailDialog(String message) {
    autoStatusChange = _getAutoStatus();

    if (message == "cancelledDeliveredToClient") {
    } else {
      if (autoStatusChange.isNotEmpty) {
        if (allowedStatus
            .where((oldValue) => autoStatusChange == (oldValue))
            .isEmpty) {
        } else {
          setState(() {
            isInitail = true;
          });
          if (autoStatusChange == "delivered" && detail.client == "yes") 
           //yes batai weight change huna ho

          
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return StatusDeliveredChangePopUp(
                      currentStatus: _getStatusTitle(detail.currentStatus),
                      newStatus: _getStatusTitle(autoStatusChange),
                      productname: detail.productName ?? "",
                      price: detail.productPrice.toString(),
                      collectedController: collectedController,
                      onNextTap: _onNextButton);
                });
          else
          print('nkknnnkknk');
          print(detail.currentStatus);

            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return StatusChangePopUp(
                    finalPackageWeight:detail.finalPackageWeight,
                    currentStatus: _getStatusTitle(detail.currentStatus),
                    newStatus: _getStatusTitle(autoStatusChange),
                    onTrackNextTap: _onTrackNextButton,
                    onDetailTap: _onDetailButton,
                    onCancelTap: _onCancelButton,
                  );
                });
        }
      }
    }
  }

  void _showConfirmDialog() {
    if (detail.currentStatus == "cancelledDeliveredToClient") {
    } else {
      if (selectedIndex == -1) {
        _showStatusErrorDialog("Please select status to be changed", true);
      } else {
        if (selectedStatus == "delivered" && detail.client == "yes")
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return StatusDeliveredChangePopUp(
                    currentStatus: _getStatusTitle(detail.currentStatus),
                    newStatus: _getStatusTitle(selectedStatus),
                    productname: detail.productName ?? "",
                    price: detail.productPrice.toString(),
                    collectedController: collectedController,
                    onNextTap: _onNextButton);
              });
        else {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return StatusChangePopUp(
                  currentStatus: _getStatusTitle(detail.currentStatus),
                  newStatus: _getStatusTitle(selectedStatus),
                  onTrackNextTap: _onTrackNextButton,
                  onDetailTap: _onDetailButton,
                  onCancelTap: _onCancelButton,
                );
              });
        }
      }
    }
  }

  void _checkStatus(int index) {
    if (this.status[index].key != detail.currentStatus) {
      if (allowedStatus
          .where((oldValue) => this.status[index].key == (oldValue))
          .isEmpty) {
      } else {
        for (var i = 0; i < forwardStatus.length; i++) {
      
          if (forwardStatus[i].key == detail.currentStatus) {
            if (forwardStatus[i]
                .status
                .where((oldValue) => this.status[index].key == (oldValue))
                .isEmpty) {
            } else {
              if (selectedIndex != -1)
                setState(() {
                  this.status[selectedIndex].isSelected = null;
                });
              selectedIndex = index;
              selectedStatus = this.status[index].key;
              setState(() {
                this.status[index].isSelected = true;
              });
            }
            break;
          }
        }
      }
    }
  }

  HubM _getHub(int hubId) {
    var obj = hub.where((oldValue) => hubId == (oldValue.id));
    if (obj.isNotEmpty) return obj.first;
  }

  String _getAutoStatus() {
    for (var i = 0; i < forwardStatus.length; i++) {
   

      if (forwardStatus[i].key == detail.currentStatus) {
        if (forwardStatus[i].status.length == 1) {
          return forwardStatus[i].status[0];
          break;
        } else if (forwardStatus[i].status.length == 2) {
          var obj = forwardStatus[i]
              .status
              .where((oldValue) => "cancelled" == (oldValue));
          if (obj.isNotEmpty) return forwardStatus[i].status[0];
          break;
        }
      }
    }
    return "";
  }

  String _getStatusTitle(String status) {
    for (var i = 0; i < forwardStatus.length; i++) {
      // if(i==1) continue;
      if (forwardStatus[i].key == status) {
        return forwardStatus[i].name;
      }
    }
    return "";
  }

  String _getStatusLogistic(String status) {
    if (status == "delivered" || status == "") return "";
    for (var i = 0; i < this.status.length; i++) {
       if(i==1) continue;
      if (this.status[i].key == status) {
        
        return this.status[i].key;
      }
    }
    return "";
  }

  void _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', "");
  }

  void _showSessionErrorDialog(String message) {
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
                  TextButton(
                    onPressed: () {
                      _logout();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  // new FlatButton(
                  //   child: new Text(
                  //     "OK",
                  //     style: TextStyle(color: MyColors.primaryColor),
                  //   ),
                  //   onPressed: () {

                  //   },
                  // ),
                ],
              ),
            ));
      },
    );
  }

  void _showStatusErrorDialog(String message, bool fromStatus) {
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
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (!fromStatus) Navigator.of(context).pop();
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  void _showDetailErrorDialog(String message) {
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
                  TextButton(
                    onPressed: () {
                      setState(() {});
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QRViewExample()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  // new FlatButton(
                  //   child: new Text(
                  //     "OK",
                  //     style: TextStyle(color: MyColors.primaryColor),
                  //   ),
                  //   onPressed: () {
                  //     setState(() {});
                  //     Navigator.pushAndRemoveUntil(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => QRViewExample()),
                  //       (Route<dynamic> route) => false,
                  //     );
                  //   },
                  // ),
                ],
              ),
            ));
      },
    );
  }

  HubM dropdownValue;
  bool isRemarksVisible = false;
  final remarkController = TextEditingController();
  final collectedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var trackNextBtn = CustomButton(
      buttonText: "Track Next",
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => QRViewExample()),
          (Route<dynamic> route) => false,
        );
      },
    );

    var editRemarks = Container(
        padding: EdgeInsets.fromLTRB(15, 0, 18, 18),
        child: TextField(
          controller: remarkController,
          obscureText: false,
          style: TextStyle(color: MyColors.darkGreyText),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintStyle: TextStyle(color: MyColors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
            ),
            filled: true,
            fillColor: MyColors.toolbarBorder,
          ),
        ));

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("PACKAGE DETAIL",
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 16, 0, 10),
                        child: StaticTextOrangeSmall(
                          staticText: "Order Status",
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.fromLTRB(9, 0, 9, 17),
                            itemCount: (status != null && status.length != null)
                                ? status.length
                                : 0,
                            itemBuilder: (BuildContext context, int index) {
                              return new GestureDetector(
                                onTap: () {
                                  print(status[index]);
                                  _checkStatus(index);
                                },
                                child: Container(
                                  height: 57,
                                  width: 72,
                                  margin: EdgeInsets.fromLTRB(3, 0, 3, 0),
                                  padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                                  child: Center(
                                      child: Text(
                                    '${status[index].name}',
                                    style: status[index].isSelected == null
                                        ? TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w500,
                                            color:
                                                status[index].isCurrentStatus ==
                                                        null
                                                    ? MyColors.ligtBlack
                                                    : MyColors.white,
                                            fontSize: 12)
                                        : TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w500,
                                            color: MyColors.white,
                                            fontSize: 12),
                                    textAlign: TextAlign.center,
                                  )),
                                  decoration: status[index].isAllowed == null
                                      ? BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color:
                                              status[index].isCurrentStatus ==
                                                      null
                                                  ? MyColors.lightGrey
                                                  : MyColors.primaryColor,
                                        )
                                      : status[index].isSelected == null
                                          ? BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: status[index]
                                                          .isCurrentStatus ==
                                                      null
                                                  ? MyColors.darkBorder
                                                  : MyColors.primaryColor,
                                            )
                                          : BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: MyColors.lightSky,
                                            ),
                                ),
                              );
                            }),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        color: MyColors.statusDivider,
                        height: 1,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(18, 16, 0, 16),
                              child: Text(
                                "Hub",
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w500,
                                    color: MyColors.ligtBlack,
                                    fontSize: 14),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(18, 16, 18, 16),
                              child: Text(
                                (dropdownValue != null &&
                                        dropdownValue.name != null)
                                    ? dropdownValue.name
                                    : "",
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w500,
                                    color: MyColors.ligtBlack,
                                    fontSize: 14),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            // Container(
                            //   margin: EdgeInsets.fromLTRB(15, 14, 14, 11),
                            //   child: DropdownButton<HubM>(
                            //       hint: Text("Select hub"),
                            //       value: dropdownValue,
                            //       icon: Icon(Icons.arrow_drop_down),
                            //       iconSize: 24,
                            //       elevation: 16,
                            //       style: TextStyle(
                            //           fontFamily: "Roboto",
                            //           fontWeight: FontWeight.w500,
                            //           color: MyColors.ligtBlack,
                            //           fontSize: 14),
                            //       underline: Container(
                            //         height: 2,
                            //         color: Colors.white,
                            //       ),
                            //       onChanged: (HubM newValue) {
                            //         setState(() {
                            //           dropdownValue = newValue;
                            //           isHubSelected = true;
                            //         });
                            //       },
                            //       items: this.hub?.map<DropdownMenuItem<HubM>>(
                            //               (HubM value) {
                            //             return DropdownMenuItem<HubM>(
                            //               value: value,
                            //               child: Text(value.name),
                            //             );
                            //           })?.toList()),
                            // ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        color: MyColors.statusDivider,
                        height: 2,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(18, 20, 0, 11),
                              child: Text(
                                "Remarks",
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w500,
                                    color: MyColors.ligtBlack,
                                    fontSize: 14),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isRemarksVisible = !isRemarksVisible;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(15, 20, 18, 18),
                                child: new SizedBox(
                                  height: 25,
                                  child: Image.asset("assets/images/plus.png"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      isRemarksVisible
                          ? editRemarks
                          : Container(
                              color: MyColors.white,
                              height: 1,
                            ),
                      Container(
                        width: 100,
                        height: 32,
                        margin: EdgeInsets.fromLTRB(18, 0, 0, 11),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            backgroundColor: MyColors.primaryColor,
                          ),
                          onPressed: () {
                            _showConfirmDialog();
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(
                              color: MyColors.white,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                            ),
                          ),
                        ),

                        // FlatButton(
                        //   shape: new RoundedRectangleBorder(
                        //     borderRadius: new BorderRadius.circular(8.0),
                        //   ),
                        //   onPressed: () {
                        //     _showConfirmDialog();
                        //   },
                        //   color: MyColors.primaryColor,
                        //   child: Text(
                        //     "Save",
                        //     style: TextStyle(
                        //       color: MyColors.white,
                        //       fontFamily: 'Roboto',
                        //       fontWeight: FontWeight.w500,
                        //       fontSize: 14.0,
                        //     ),
                        //   ),
                        // ),
                      ),
                      Container(
                        color: MyColors.lightGrey,
                        height: 7,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(18, 24, 0, 11),
                              child: StaticTextOrangeSmall(
                                  staticText: "SENDER DETAILS"),
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //   _navigateSenderAndSuccess(_ctx);
                            //   },
                            //
                            //   child: _getStatusLogistic((detail !=null && detail.currentStatus!=null)  ? detail.currentStatus : "")=="forwardLogistic" ? Container(
                            //     padding: EdgeInsets.fromLTRB(20, 24, 20, 20),
                            //     child: detail.client=="no" ? new SizedBox(
                            //       height: 18,
                            //       child: Image.asset("assets/images/edit.png"),
                            //     ):new SizedBox(
                            //       height: 0,
                            //     )
                            //     ,
                            //   ) :   Container(
                            //     height: 0,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(18, 0, 0, 10),
                        child: Text(
                          (detail != null && detail.senderName != null)
                              ? detail.senderName
                              : "",
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w700,
                              color: MyColors.ligtBlack,
                              fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 18, 14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new SizedBox(
                                height: 18,
                                width: 18,
                                child: Image.asset("assets/images/path.png"),
                              ),
                              new SizedBox(
                                  height: 18,
                                  width: 160,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(18, 0, 0, 0),
                                    child:
                                        new TextGrey(text: "Pickup Location"),
                                  )),
                              new Flexible(
                                child: new TextDarkGrey(
                                  text: (detail != null &&
                                          detail.senderLocation != null)
                                      ? detail.senderLocation
                                      : "",
                                ),
                                flex: 1,
                              ),
                            ],
                          )),
                      Container(
                        
                          padding: EdgeInsets.fromLTRB(17, 0, 18, 14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new SizedBox(
                                height: 16,
                                width: 16,
                                child: Image.asset("assets/images/email.png"),
                              ),
                              new SizedBox(
                                  height: 18,
                                  width: 160,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(18, 0, 0, 0),
                                    child: new TextGrey(text: "Email"),
                                  )),
                              new Flexible(
                                child: new TextDarkGrey(
                                  text: (detail != null && detail.email != null)
                                      ? detail.email
                                      : "",
                                ),
                                flex: 1,
                              ),
                            ],
                          )),
                      Container(
                          padding: EdgeInsets.fromLTRB(17, 0, 18, 14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new SizedBox(
                                height: 18,
                                width: 14,
                                child: Image.asset("assets/images/phone.png"),
                              ),
                              new SizedBox(
                                  height: 18,
                                  width: 160,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(18, 0, 0, 0),
                                    child: new TextGrey(text: "Phone. No."),
                                  )),
                              new Flexible(
                                child: new TextDarkGrey(
                                  text: (detail != null &&
                                          detail.senderContact != null)
                                      ? detail.senderContact
                                      : "",
                                ),
                                flex: 1,
                              ),
                            ],
                          )),
                      Container(
                          padding: EdgeInsets.fromLTRB(17, 0, 18, 25),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new SizedBox(
                                height: 18,
                                width: 14,
                                child: Image.asset("assets/images/path.png"),
                              ),
                              new SizedBox(
                                  height: 18,
                                  width: 160,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(18, 0, 0, 0),
                                    child: new TextGrey(text: "Full Address"),
                                  )),
                              new Flexible(
                                child: new TextDarkGrey(
                                  text: (detail != null &&
                                          detail.senderGoogleAddress != null)
                                      ? detail.senderGoogleAddress
                                      : "",
                                ),
                                flex: 1,
                              ),
                            ],
                          )),
                      Container(
                        color: MyColors.lightGrey,
                        height: 7,
                      ),
                      Container(
                        color: MyColors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(18, 26, 0, 11),
                              child: StaticTextOrangeSmall(
                                  staticText: "RECEIVER DETAILS"),
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //   _navigateReceiverAndSuccess(_ctx);
                            //   },
                            //   child:  _getStatusLogistic((detail !=null && detail.currentStatus!=null)  ? detail.currentStatus : "")=="forwardLogistic" ? Container(
                            //     padding: EdgeInsets.fromLTRB(20, 24, 20, 20),
                            //     child: new SizedBox(
                            //       height: 18,
                            //       child: Image.asset("assets/images/edit.png"),
                            //     ),
                            //   ) :  Container(
                            //     height: 0,
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(16, 0, 0, 10),
                        child: Text(
                          (detail != null && detail.receiverName != null)
                              ? detail.receiverName
                              : "",
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w700,
                              color: MyColors.ligtBlack,
                              fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 18, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new SizedBox(
                                height: 18,
                                width: 18,
                                child: Image.asset("assets/images/path.png"),
                              ),
                              new SizedBox(
                                  height: 18,
                                  width: 160,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(18, 0, 0, 0),
                                    child: new TextGrey(text: "Drop Location"),
                                  )),
                              new Flexible(
                                child: new TextDarkGrey(
                                  text: (detail != null &&
                                          detail.receiverGoogleAddress != null)
                                      ? detail.receiverGoogleAddress
                                      : "",
                                ),
                                flex: 1,
                              ),
                            ],
                          )),
                      ((detail != null && detail.client != null)
                                  ? detail.client
                                  : "") ==
                              "no"
                          ? Container(
                              padding: EdgeInsets.fromLTRB(17, 14, 18, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new SizedBox(
                                    height: 16,
                                    width: 16,
                                    child:
                                        Image.asset("assets/images/email.png"),
                                  ),
                                  new SizedBox(
                                      height: 18,
                                      width: 160,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(18, 0, 0, 0),
                                        child: new TextGrey(text: "Landmark"),
                                      )),
                                  new Flexible(
                                    child: new TextDarkGrey(
                                      text: (detail != null &&
                                              detail.receiverNearestLandmark !=
                                                  null)
                                          ? detail.receiverNearestLandmark
                                          : "",
                                    ),
                                    flex: 1,
                                  ),
                                ],
                              ))
                          : Container(
                              height: 0,
                            ),
                      Container(
                          padding: EdgeInsets.fromLTRB(17, 14, 18, 25),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new SizedBox(
                                height: 18,
                                width: 14,
                                child: Image.asset("assets/images/phone.png"),
                              ),
                              new SizedBox(
                                  height: 18,
                                  width: 160,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(18, 0, 0, 0),
                                    child: new TextGrey(text: "Phone. No."),
                                  )),
                              new Flexible(
                                child: new TextDarkGrey(
                                  text: (detail != null &&
                                          detail.receiverContact != null)
                                      ? detail.receiverContact
                                      : "",
                                ),
                                flex: 1,
                              ),
                            ],
                          )),
                      Container(
                        color: MyColors.lightGrey,
                        height: 7,
                      ),
                      ((detail != null && detail.client != null)
                                  ? detail.client
                                  : "") ==
                              "yes"
                          ? Container(
                              color: MyColors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(18, 16, 0, 11),
                                    child: StaticTextOrangeSmall(
                                        staticText: "PACKAGE DETAILS"),
                                  ),
                                  // GestureDetector(
                                  //     onTap: () {
                                  //    _navigatePackageAndSuccess(_ctx);
                                  //     },
                                  //   child: (_getStatusLogistic((detail !=null && detail.currentStatus!=null)  ? detail.currentStatus : "")=="orderPlaced" || _getStatusLogistic((detail !=null && detail.currentStatus!=null)  ? detail.currentStatus : "")=="orderConfirmed")  ?
                                  //   Container(
                                  //     padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                  //     child: new SizedBox(
                                  //       height: 18,
                                  //       child: Image.asset("assets/images/edit.png"),
                                  //     ),
                                  //   ) :  Container(
                                  //     color: MyColors.lightGrey,
                                  //     height: 0,
                                  //   ),
                                  // ),
                                ],
                              ),
                            )
                          : Container(
                              color: MyColors.lightGrey,
                              height: 0,
                            ),
                      ((detail != null && detail.client != null)
                                  ? detail.client
                                  : "") ==
                              "yes"
                          ? Container(
                              margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 12, 0, 12),
                                      child: Text(
                                          "Product Name : ${detail.productName}",
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              fontWeight: FontWeight.w500,
                                              color: MyColors.darkGreyText,
                                              fontSize: 14))),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
                                    color: MyColors.darkBorder,
                                    height: 1,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                 Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    Container(
      margin: EdgeInsets.fromLTRB(16, 12, 0, 4),
      child: TextGrey(text: "Weight"),
    ),

    if (newweightobj.newweight1 != "")
      Container(
        margin: EdgeInsets.fromLTRB(15, 0, 0, 14),
        child: Text(
          "${newweightobj.newweight1}kg",
          style: TextStyle(
            fontFamily: "Roboto",
            fontWeight: FontWeight.w500,
            color: MyColors.darkGreyText,
            fontSize: 20,
          ),
        ),
      )
    else
      Container(
        margin: EdgeInsets.fromLTRB(15, 0, 0, 14),
        child: Text(
          "${detail.finalPackageWeight}kg",
          style: TextStyle(
            fontFamily: "Roboto",
            fontWeight: FontWeight.w500,
            color: MyColors.darkGreyText,
            fontSize: 20,
          ),
        ),
      ),
  ],
),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                2, 12, 0, 4),
                                            child: TextGrey(text: "Price"),
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 0, 14),
                                            child: Text(
                                                "Rs ${detail.productPrice}",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        MyColors.darkGreyText,
                                                    fontSize: 20)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: MyColors.lightGrey,
                              ),
                            )
                          : Container(
                              color: MyColors.lightGrey,
                              height: 0,
                            ),
                    ],
                  ),
                )),
        bottomNavigationBar: trackNextBtn);
  }

  @override
  void onDetailGetError(String errorTxt) {
    setState(() {
      _isLoading = false;
    });
    _showDetailErrorDialog(errorTxt);
  }

  @override
  void onStatusError(String errorTxt) {
    setState(() {
      _isLoading = false;
    });
    _showStatusErrorDialog(errorTxt, false);
  }

  @override
  void onSessionExpired(String errorTxt) {
    setState(() {
      _isLoading = false;
    });
    _showSessionErrorDialog(errorTxt);
  }

  @override
  void onDetailGetSuccess(
      PackageDetailM detail,
      List<StatusM> status,
      List<HubM> hub,
      List<dynamic> allowedStatus,
      List<ForwardStatus> permissionStatus,
      int employeeHub) {
    setState(() {
      this.detail = detail;
      this.status = status;
      this.hub = hub;
      this.allowedStatus = allowedStatus;
      this.forwardStatus = permissionStatus;
      this.employeeHub = employeeHub;
      dropdownValue = _getHub(detail.hubId);
      _isLoading = false;
    });

    if (isFirst) _showInitailDialog(this.detail.currentStatus);
  }

  @override
  void onStatusChangeSuccess() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => QRViewExample()),
      (Route<dynamic> route) => false,
    );
  }
}

