import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logistics/packagedetailpage/package_detail_screen.dart';
import 'package:logistics/response/LoginM.dart';
import 'package:logistics/reusable/custombutton.dart';
import 'package:logistics/scan.dart';
import 'package:logistics/utils/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/LoginApi.dart';
import 'login_presenter.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> implements LoginScreenContract{
  bool _isLoading = false;
  BuildContext _ctx;
  LoginScreenPresenter _presenter;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  _LoginScreenState() {

    _presenter = new LoginScreenPresenter(this);

  }



  void _showDialog(String message) {
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
      setState(() => _isLoading = true);
      _presenter.doLogin(emailController.text, passwordController.text);

  }
  // Clean up the controller when the widget is disposed.
  // Clean up the controller when the widget is disposed.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var editUserName = Container(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: TextField(
          controller: emailController,
          obscureText: false,
          style: TextStyle(color: MyColors.primaryColor),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintStyle: TextStyle(color: MyColors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
            ),
            filled: true,
            fillColor: MyColors.lightGrey,
          ),
        ));

    var editPassword = Container(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: TextField(
          controller : passwordController,
          obscureText: true,
          style: TextStyle(color: MyColors.primaryColor),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintStyle: TextStyle(color: MyColors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
            ),
            filled: true,
            fillColor: MyColors.lightGrey,
          ),
        ));

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: _isLoading ? new Center(
          child: new CircularProgressIndicator(
            backgroundColor: MyColors.primaryColor,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),)) :Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background_image.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SingleChildScrollView(
              reverse: true,
              child:  Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  new Container(
                    alignment: Alignment.topCenter,
                    padding: new EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .15,
                        right: 32.0,
                        left: 32.0),
                    child: SizedBox(
                      height: 70,
                      width: 170,
                      child: Image.asset("assets/images/logo.png"),
                    ),
                  ),
                  new Container(
                    alignment: Alignment.topCenter,
                    padding: new EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .35,
                        right: 32.0,
                        left: 32.0),
                    child: new Container(
                      width: MediaQuery.of(context).size.width,
                      child: new Card(
                        color: MyColors.primary20,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0)),
                      ),
                    ),
                  ),
                  new Container(
                    alignment: Alignment.topCenter,
                    padding: new EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .33,
                        right: 17.0,
                        left: 17.0,
                    ),
                    child:  new Container(
                            width: MediaQuery.of(context).size.width,
                            child: new Card(
                                color: MyColors.white,
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.0)),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    SizedBox(height: 28),
                                    Text(
                                      "Login to your account",
                                      style: TextStyle(
                                          fontFamily: "Roboto",
                                          fontWeight: FontWeight.w700,
                                          color: MyColors.ligtBlack,
                                          fontSize: 24),
                                      textAlign: TextAlign.center,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(18, 28, 0, 0),
                                      child: Text(
                                        "Username",
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w500,
                                            color: MyColors.ligtGreyText,
                                            fontSize: 12),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),

                                    editUserName,
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(18, 16, 0, 0),
                                      child: Text(
                                        "Password",
                                        style: TextStyle(
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w500,
                                            color: MyColors.ligtGreyText,
                                            fontSize: 12),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    editPassword,
                                    SizedBox(height: 4),
                                    GestureDetector(
                                        onTap: () {
                                          _submit();
                                        },
                                        child :
                                    Container(
                                        margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                                        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                                      child: Text(
                                        "Login",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                       color: MyColors.white,
                                       fontFamily: 'Roboto',
                                     fontWeight: FontWeight.w500,
                                            fontSize: 14.0,
                                           ),
                                            ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: MyColors.primaryColor ,
                                        )
                                    ))
                                  ],
                                )),
                          ),
                  )
                ],
              ),
            ],
          ))
        ],
      ),
    );
  }

  @override
  void onLoginError(String errorTxt) {
    //_onHideLoading();
    setState(() => _isLoading = false);
  //  _showSnackBar(errorTxt);
    _showDialog(errorTxt);

  }

  @override
  void onLoginSuccess(LoginResponse response) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => _isLoading = false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => QRViewExample()),
          (Route<dynamic> route) => false,
    );
  }
}

