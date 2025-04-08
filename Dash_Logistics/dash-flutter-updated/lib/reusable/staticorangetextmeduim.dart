import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:logistics/utils/color.dart';

class StaticTextOrangeMeduim extends StatelessWidget{
  final String staticText;

  const StaticTextOrangeMeduim({Key key, this.staticText}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      staticText,
      style: TextStyle(fontFamily :"Roboto",fontWeight: FontWeight.w500,color: MyColors.primaryColor,fontSize: 14),
      textAlign: TextAlign.left,
    );
  }

}