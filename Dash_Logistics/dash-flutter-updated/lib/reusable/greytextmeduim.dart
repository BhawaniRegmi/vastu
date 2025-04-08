import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:logistics/utils/color.dart';

class TextGreyMeduim extends StatelessWidget{
  final String text;

  const TextGreyMeduim({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontFamily :"Roboto",fontWeight: FontWeight.w500,color: MyColors.ligtGreyText,fontSize: 12),
      textAlign: TextAlign.left,
    );
  }

}