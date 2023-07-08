import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sonata/Views/Widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final double borderRadius;
  final double textSize;
  final Color buttonColor;
  final Color textColor;
  final VoidCallback onPressed;
  final FontWeight textFontWeight;
  final String? iconPath;

  const CustomButton({
    required this.text,
    this.borderRadius = 30,
    this.height = 40,
    this.width = double.infinity,
    this.textSize = 16,
    this.buttonColor = const Color(0xffFFFFFF),
    this.textColor = const Color(0xff584B4B),
    required this.onPressed,
    this.textFontWeight = FontWeight.w600,
    this.iconPath,
    required String fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      height: height,
      minWidth: width,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      color: buttonColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconPath != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SvgPicture.asset(
                iconPath!,
              ),
            ),
          const SizedBox(
              width: 8), // Add some spacing between the icon and text
          CustomText(
            text: text,
            fontSize: textSize,
            fontWeight: textFontWeight,
            fontColor: textColor,
            fontFamily: 'Chillax',
          ),
        ],
      ),
    );
  }
}
