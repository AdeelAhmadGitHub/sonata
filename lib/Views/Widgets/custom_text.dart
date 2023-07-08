import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? height;
  final Color? fontColor;
  final TextAlign? textAlign;
  final double? letterSpacing;
  final TextOverflow? overflow;
  final int? maxLines;

  const CustomText({
    @required this.text,
    @required this.fontFamily,
    this.fontWeight,
    this.fontSize,
    this.height,
    this.fontColor,
    this.textAlign,
    this.letterSpacing,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      textAlign: textAlign,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        height: height,
        fontFamily: fontFamily,
        color: fontColor,
        letterSpacing: letterSpacing,
      ),
      overflow: overflow ?? TextOverflow.clip,
      maxLines: maxLines,
    );
  }
}
