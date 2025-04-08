import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logistics/utils/color.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;

  final GestureTapCallback onPressed;

  const CustomButton({Key key, this.buttonText, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
    return Container(
      color: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(16, 16, 16, 22),
        height: 48,
        child: TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            backgroundColor: MyColors.primaryColor,
          ),
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: TextStyle(
              color: MyColors.white,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }
}
