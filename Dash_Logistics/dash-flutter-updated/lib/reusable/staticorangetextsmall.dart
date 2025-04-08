import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:logistics/utils/color.dart';

class StaticTextOrangeSmall extends StatelessWidget{
  final String staticText;

  const StaticTextOrangeSmall({Key key, this.staticText}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      staticText,
      style: TextStyle(fontFamily :"Roboto",fontWeight: FontWeight.w500,color: MyColors.primaryColor,fontSize: 12),
      textAlign: TextAlign.left,
    );
  }

}