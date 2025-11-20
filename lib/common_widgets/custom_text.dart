import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomText extends StatelessWidget {
  //String textStyle = "";
  BuildContext? context;

  double fontSize = 16.0;
  Color? color;
  String txt = "";
  String? family;
  TextAlign align = TextAlign.start;
  bool isTab = false;
  TextDecoration decorate = TextDecoration.none;
  TextOverflow? overflow;
  var maxLines = 50;
  bool scaleDown = false;
  FontWeight? fontWeight;
  double? height;

  CustomText({
    required this.txt,
    this.context,
    this.color,
    this.family,
    this.fontSize = 16.0,
    this.align = TextAlign.start,
    this.isTab = false,
    this.overflow,
    this.decorate = TextDecoration.none,
    this.maxLines = 50,
    this.scaleDown = false,
    this.fontWeight,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return scaleDown
        ? FittedBox(fit: BoxFit.scaleDown, child: textView())
        : textView();
  }

  textView() {
    return Text(
      "\u200E${txt}",
      maxLines: isTab ? 1 : maxLines,
      textAlign: align,
      style: isTab
          ? TextStyle(
              fontFamily: family,
              color: color,
              fontSize: fontSize,
              overflow: overflow,
            )
          : TextStyle(
              fontFamily: family,
              fontSize: fontSize,
              color: color,
              letterSpacing: 0.2,
              overflow: overflow,
              decoration: decorate,
              fontWeight: fontWeight,
            ),
    );
  }
}
