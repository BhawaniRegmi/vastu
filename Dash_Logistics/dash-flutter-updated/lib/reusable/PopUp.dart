import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logistics/api/DetailApi.dart';
import 'package:logistics/newChange/weightTextField.dart';
import 'package:logistics/packagedetailpage/detail_presenter.dart';
 import 'package:logistics/response/PackageDetailM.dart';
import 'package:logistics/utils/color.dart';

// import '../response/PackageDetailM.dart';

class StatusChangePopUp extends StatelessWidget {

  final String buttonText;
 final String finalPackageWeight;
  final VoidCallback onTrackNextTap;
  final VoidCallback onCancelTap;
  final VoidCallback onDetailTap;
  final String currentStatus;
  final String newStatus;
  PackageDetailM detail=PackageDetailM();

//PackageDetailM detail=PackageDetailM() ;


   StatusChangePopUp(
      {Key key,
      this.finalPackageWeight,
      this.buttonText,
      this.currentStatus,
      this.newStatus,
      @required this.onTrackNextTap,
      @required this.onDetailTap,
      @required this.onCancelTap})
      : super(key: key);


    WeightInputDialog newweightobj=WeightInputDialog();





  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return new AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14.0))),
      insetPadding: EdgeInsets.all(16),
      contentPadding: EdgeInsets.fromLTRB(25, 38, 25, 38),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      content: SingleChildScrollView(
        child: Container(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                      color: MyColors.lightSky,
                    ),
                  )
                ],
              ),
              SizedBox(height: 13,),
       
    if (newweightobj.newweight1 == "")
    if(currentStatus=="Order Placed" )
    
     Text(
  '" Current Weight is ${finalPackageWeight} kg"',
  
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
)     
  else
                         SizedBox(),
   //if(newweightobj.newweight1=="")    
 if(currentStatus=="Order Placed")
 
                      Container(
                    width: 138,
                    height: 48,
                    margin: EdgeInsets.fromLTRB(0, 32, 8, 11),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        backgroundColor: MyColors.blue,
                      ),
                      onPressed: () {
                        // Navigate to a new screen
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WeightInputDialog()),
                        );

                       print(finalPackageWeight);
                       // finalPackageWeight=n
                       // onDetailTap();
                        //Navigator.of(context).pop();
                      },
                      child: 
                      Text(
                        "Change Weight?", 
                       //currentStatus,
                        style: TextStyle(
                          color: MyColors.white,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  )
                  else 
SizedBox(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 138,
                    height: 48,
                    margin: EdgeInsets.fromLTRB(0, 32, 8, 11),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        backgroundColor: MyColors.blue,
                      ),
                      onPressed: () {
                        onDetailTap();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "View details",
                        style: TextStyle(
                          color: MyColors.white,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 138,
                    height: 48,
                    margin: EdgeInsets.fromLTRB(8, 32, 0, 11),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        backgroundColor: MyColors.primaryColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        onTrackNextTap();
                      },
                      child: Text(
                        "OK",
                        style: TextStyle(
                          color: MyColors.white,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                width: 138,
                height: 48,
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(18, 0, 0, 0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    backgroundColor: MyColors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    onCancelTap();
                  },
                  child: Text(
                    "CANCEL SCAN",
                    style: TextStyle(
                      color: MyColors.darkOrange,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      actions: <Widget>[],
    );
  }
}



