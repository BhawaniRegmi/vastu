import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:logistics/utils/color.dart';

class TextRegularSecondary extends StatelessWidget{
  final String text;

  const TextRegularSecondary({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontFamily :"Roboto",fontWeight: FontWeight.w400,color: MyColors.darkGreyText,fontSize: 14),
      textAlign: TextAlign.left,
    );
  }

}