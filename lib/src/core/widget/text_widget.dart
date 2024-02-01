import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personal_expense_tracker/src/core/constant/font.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final String fontFamily;
  final Color? color;
  final double fontSize;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final TextAlign? textAlign;
  final double? height;
  const TextWidget(
    this.text, {
    super.key,
    this.color = Colors.black,
    this.maxLines,
    this.height,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.textOverflow = TextOverflow.visible,
    this.textAlign = TextAlign.center,
    this.fontFamily = FontFamily.roboto,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: textOverflow,
      textAlign: textAlign,
      style: TextStyle(
        height: height,
        fontFamily: fontFamily,
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize.sp,
      ),
    );
  }
}

TextStyle commonTextStyle({
  double? height,
  Color? color,
  FontWeight? fontWeight,
  required double fontSize,
  String? fontFamily,
  int? maxLines,
  TextOverflow? textOverflow,
  TextAlign? textAlign,
}) {
  return TextStyle(
      height: height,
      fontFamily: fontFamily,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize.sp);
}
