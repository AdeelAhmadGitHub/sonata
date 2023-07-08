import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../custom_text.dart';

class CustomBottomSheet extends StatelessWidget {
  final String editeText;
  final String deleteText;
  final VoidCallback? editeOnTap;
  final VoidCallback? deleteOnTap;
  const CustomBottomSheet(
      {Key? key,
      required this.editeText,
      required this.deleteText,
      this.editeOnTap,
      this.deleteOnTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 287.h,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(top: 35.0.h, left: 20.0.w, right: 20.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: editeOnTap,
              child: CustomText(
                text: editeText,
                fontSize: 24,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            const Divider(),
            SizedBox(
              height: 5.h,
            ),
            GestureDetector(
              onTap: deleteOnTap,
              child: CustomText(
                text: deleteText,
                fontSize: 24,
                fontColor: Color(0xffE76880),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
