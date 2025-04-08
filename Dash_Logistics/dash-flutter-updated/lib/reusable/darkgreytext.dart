import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:logistics/utils/color.dart';

class TextDarkGrey extends StatelessWidget{
  final String text;

  const TextDarkGrey({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontFamily :"Roboto",fontWeight: FontWeight.w500,color: MyColors.darkGreyText,fontSize: 12),
      textAlign: TextAlign.left,
    );
  }

}